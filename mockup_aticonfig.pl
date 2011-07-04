#!/usr/bin/perl

use Switch;
use Data::Dumper;

switch (join ' ', @ARGV) {
	case /--list-adapters/ {
	print <<EOL;
* 0. 03:00.0 AMD Radeon HD 6990
  1. 04:00.0 AMD Radeon HD 6990
  2. 09:00.0 AMD Radeon HD 6990
  3. 0a:00.0 AMD Radeon HD 6990

* - Default adapter
EOL
	}
	case /--adapter=all --odgt/ {
	print <<EOL;

Adapter 0 - AMD Radeon HD 6990
            Sensor 0: Temperature - 79.00 C

Adapter 1 - AMD Radeon HD 6990
            Sensor 0: Temperature - 82.50 C

Adapter 2 - AMD Radeon HD 6990
            Sensor 0: Temperature - 81.50 C

Adapter 3 - AMD Radeon HD 6990
            Sensor 0: Temperature - 83.50 C
EOL
    }
   	case /get fanspeed 0/ {
   	print <<EOL;
Fan speed query: 
Query Index: 0, Speed in percent
Result: Fan Speed: 65%

EOL
   	}
   	case /--adapter=all --od-getclocks/ {
   	print <<EOL;

Adapter 0 - AMD Radeon HD 6990
                            Core (MHz)    Memory (MHz)
           Current Clocks :    830           1250
             Current Peak :    830           1250
  Configurable Peak Range : [500-1200]     [1250-1500]
                 GPU load :    99%

Adapter 1 - AMD Radeon HD 6990
                            Core (MHz)    Memory (MHz)
           Current Clocks :    830           1250
             Current Peak :    830           1250
  Configurable Peak Range : [500-1200]     [1250-1500]
                 GPU load :    99%

Adapter 2 - AMD Radeon HD 6990
                            Core (MHz)    Memory (MHz)
           Current Clocks :    830           1250
             Current Peak :    830           1250
  Configurable Peak Range : [500-1200]     [1250-1500]
                 GPU load :    99%

Adapter 3 - AMD Radeon HD 6990
                            Core (MHz)    Memory (MHz)
           Current Clocks :    830           1250
             Current Peak :    830           1250
  Configurable Peak Range : [500-1200]     [1250-1500]
                 GPU load :    99%
EOL
   	}
}
