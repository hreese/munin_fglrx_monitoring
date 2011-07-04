package Aticonfig;

=head1 NAME

Aticonfig - (Somewhat limited) Interface to the fglrx aticonfig tool

=head1 VERSION

Version 0.3

=cut

our $VERSION = '0.3';

use warnings;
use strict;
use Carp;
use Data::Dumper;

use base 'Exporter';
our @EXPORT = qw( get_adapter_list get_temperature get_clock get_fanspeed values );

=head1 CONSTRUCTOR AND STARTUP

=head2 new()

Creates and returns a new Aticonfig object.

=cut

sub new {
    my ( $class, %config ) = @_;

    my $self = {
        x11_display        => ':0',
        aticonfig_bin      => '/usr/bin/aticonfig',
        fanspeed_blacklist => {
			1 => '2. GPU',
			3 => '2. GPU',
		},
		%config
    };

	$self = bless $self, $class;

    $self->get_adapter_list();

    return $self;
}

sub _exec_command {
    my ( $self, $command ) = @_;
    my $retval;
    eval {
        local $SIG{ALRM} = sub { croak "Timeout while waiting for \"$command\" to finish." };
        alarm 10;    # 10 seconds timeout
        open my $proc_f, '-|', $command or croak "Unable to read from process \"$command\".";
        local $/;
        $retval = <$proc_f>;
        alarm 0;
        close $proc_f;
    };
    return $retval;
}

sub get_adapter_list {
	my ( $self, @args ) = @_;

    my $output = $self->_exec_command( "DISPLAY=$self->{x11_display} $self->{aticonfig_bin} --list-adapters" );
    $output =~ s/^\* /  /g;
    for ( split /^/, $output ) {
        if (m/^\s*(\d+)\.\s+([0-9a-f.:]+)\s(.*)$/) {
            $self->{gpu}->{$1} = { id => $1, pciid => $2, name => $3 };
        }
    }
	return $self->values();
}

sub get_temperature {
	my ( $self, @args ) = @_;

    my $output = $self->_exec_command( "DISPLAY=$self->{x11_display} "
            . "$self->{aticonfig_bin} --adapter=all --odgt" );
    my $active_adapter = -1;
    for ( split /^/, $output ) {
        if (m/^Adapter (\d+)/) {
            $active_adapter = $1;
        }
        if (m/Sensor 0: Temperature - ([0-9.]+) C/) {
            $self->{gpu}->{$active_adapter}->{temp} = $1;
        }
    }
	return $self->values();
}

sub get_clock {
	my ( $self, @args ) = @_;

    my $output = $self->_exec_command( "DISPLAY=$self->{x11_display} "
            . "$self->{aticonfig_bin} --adapter=all --od-getclocks" );
    my $active_adapter = -1;
    for ( split /^/, $output ) {
        if (m/^Adapter (\d+)/) {
            $active_adapter = $1;
        }
        if (m/Current Clocks :\s+([0-9.]+)\s+([0-9.]+)/) {
            $self->{gpu}->{$active_adapter}->{current_clock_core} = $1;
            $self->{gpu}->{$active_adapter}->{current_clock_mem}  = $2;
        }
        if (m/GPU load :\s+([0-9.]+)\%/) {
            $self->{gpu}->{$active_adapter}->{gpu_load} = $1;
        }
    }
	return $self->values();
}

sub get_fanspeed {
	my ( $self, @args ) = @_;

    foreach my $a ( keys %{$self->{gpu}} ) {
        next if defined $self->{fanspeed_blacklist}->{$a};
        my $output = $self->_exec_command( "DISPLAY=$self->{x11_display}.${a} "
                . "$self->{aticonfig_bin} --pplib-cmd=\"get fanspeed 0\"" );
        if ( $output =~ m/Result: Fan Speed: ([0-9.]+)/s ) {
            $self->{gpu}->{$a}->{fanspeed} = $1;
        }
    }
	return $self->values();
}

sub values {
	my ( $self, @args ) = @_;

	return \%{$self->{gpu}};
}

1;
