# File: process.pl
# Usage from command line:
#   perl process.pl < input.txt

#!/usr/bin/perl

# Make perl unicode-aware so we can use things like \p{Greek}:
use utf8;

# Stop perl from complaining about mulit-byte output:
use open ':std', ':encoding(UTF-8)';

# Process each line from the redirected input file:
while ($input = <STDIN>) {

    # Match all datums that begin with a Greek letter and end with a Cyrillic letter:
    my @matches = ($input =~ /(\b\p{Greek}\S*\p{Cyrillic}\b)/g);

    # Print each match:
    foreach my $x (@matches) {
        print "$x\n";
    }
}
