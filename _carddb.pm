#!/usr/bin/perl

use Data::Dumper;

%cards = (
	0 => {
		name	=> 'AMD Radeon HD 6990 #1 (Core 1) [Heiko]',
		display => '0.0',
		},
	1 => {
		name	=> 'AMD Radeon HD 6990 #1 (Core 2) [Heiko]',
		display => '0.1',
		},
	3 => {
		name	=> 'AMD Radeon HD 6990 #2 (Core 1) [Heiko]',
		display => '0.2',
		},
	4 => {
		name	=> 'AMD Radeon HD 6990 #2 (Core 2) [Heiko]',
		display => '0.3',
		},
);

print Dumper(\%cards);
