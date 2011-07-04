#!/usr/bin/perl 

use strict;
use warnings;
use Munin::Plugin;
use Switch;
use Data::Dumper;
use Aticonfig;
use vars qw($ATICONFIG);

if ( defined($ARGV[0]) and $ARGV[0] eq "autoconf" ) {
	if ( -x $ATICONFIG ) {
		print "yes\n";
	} else {
		print "no (no aticonfig binary found.)\n";
	}
	exit 0;
}

if ( defined($ARGV[0]) and $ARGV[0] eq "config" ) {
	# headers
	print "graph_title"
}

get_adapter_list();
get_temp();
get_clock();
get_fanspeed();
