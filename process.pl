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

    #breaks it up into data chunks
    @datums = split(' ', $input);
    foreach (@datums) {
        # Match all datums that begin with a Greek letter and end with a Cyrillic letter:
        if ($_ =~ /(\b\p{Greek}\S*\p{Cyrillic}\b)/g) {
            push(@matches, $_);     #pushes data to matches array
        }
        if ($_ =~ /j/g) {
            push(@matches, $_);
        }
    }
    # Print each match:
    foreach (@matches) {
        print $_ ;
        print "\n";
    }
}
