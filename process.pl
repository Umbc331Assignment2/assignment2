# File: process.pl
# Usage from command line:
#   perl process.pl < input.txt


#!/usr/bin/perl


use warnings;
# Make perl unicode-aware so we can use things like \p{Greek}:
use utf8;
# Stop perl from complaining about mulit-byte output:
use open ':std', ':encoding(UTF-8)';
# Suppress warnings about smartmatch being experimental
# Found here: http://blogs.perl.org/users/mike_b/2013/06/a-little-nicer-way-to-use-smartmatch-on-perl-518.html
no if $] >= 5.017011, warnings => 'experimental::smartmatch';


# The three basic patterns:
my @patterns = (
    # Match datum beginning with a Greek letter and ending with a Cyrilli letter:
    qr/^\p{Greek}\S*\p{Cyrillic}$/,
    
    # Match any datum containing balanced square brackets.
    # This one is confusing. The espaced brackets, '\[' or '\]' match actual brackets
    # in the string, while others, '[' or ']', are for character classes:
    qr/[^\[]*\[[^\]]*\]\S*/,
    
    # Match any datum that contains at least two double letters in a row:
    qr/\S*(\p{L})\1(\p{L})\2\S*/,

	# (Will be) match any datum that is a same character repeated prime number times
	# Derived from http://montreal.pm.org/tech/neil_kandalgaonkar.shtml
	#qr/^(([a-zA-Z])\2+?)\1+$/
);

# Hashmap for storing the matched datums and frequencies
my %matches;

# Scalar for storing most recent integer seen
my $integer = "empty";

# Process each line from the redirected input file:
while ($input = <STDIN>) {

    # breaks it up into data chunks delimited by whitespace:
    @datums = split('\s+', $input);
    foreach my $datum (@datums) {

        # capture basic patterns
        if ($datum ~~ @patterns) {
            $matches{$datum}++;
        }

        # capture integer if larger than last integer seen
        if ($datum =~ /^\-?\d*\d$/) { 
            if (($integer ne "empty") && ($datum > $integer)) {
                $matches{$datum}++;
            }
	    $integer = $datum;
        }        
    }
}

# Sort the matches by value
# Found here: http://perldoc.perl.org/functions/sort.html
@sortedMatches = sort { $matches{$b} <=> $matches{$a} } keys %matches;

# Print each match:
foreach (@sortedMatches) {
    print $_, "\n";
}
