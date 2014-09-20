# File: process.pl
# Usage from command line:
#   perl process.pl < input.txt


#!/usr/bin/perl


use warnings;
# Make perl unicode-aware so we can use things like \p{Greek}:
use utf8;
# Stop perl from complaining about mulit-byte output:
use open ':std', ':encoding(UTF-8)';


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
);

# Hashmap for storing the matched datums and frequencies
my %matches;

# Process each line from the redirected input file:
while ($input = <STDIN>) {

    #breaks it up into data chunks delimited by whitespace:
    @datums = split('\s+', $input);
    foreach my $datum (@datums) {
        if ($datum ~~ @patterns) {
            $matches{$datum}++;
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
