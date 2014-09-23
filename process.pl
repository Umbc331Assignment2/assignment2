#!/usr/bin/perl
#############################################
# File: process.pl
# Usage from command line:
#   perl process.pl < input.txt
#############################################

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

    # Matches Digits
    qr/^\-?\d*\d$/,

    # match any datum that is a same character repeated a (NOT) prime number times
    # Derived from http://montreal.pm.org/tech/neil_kandalgaonkar.shtml
    qr/^(([a-zA-Z])\2+?)\1+$/,
);

# Hashmap of counters, key being the rule ID
my %ruleFreq;

# Fill it with 0's, so that the output shows the counts even when 0
for ($i = 0; $i < 5; $i++) {
    $ruleFreq{$i} = 0;
    }

my @ruleNames = (
    "Starts with Greek, ends with Cyrillic",
    "Balanced square brackets",
    "Distinct double letters",
    "Biggest-yet integers",
    "Character repeated a prime number of times"
    );

# Scalar for storing most recent integer seen
my $integer = "empty";

# Process each line from the redirected input file:
while ($input = <STDIN>) {

    # Breaks it up into data chunks delimited by whitespace:
    @datums = split('\s+', $input);
    foreach my $datum (@datums) {
        # Capture basic patterns
        for ($i = 0; $i < 3; $i++) {
            if ($datum =~ $patterns[$i]) {
                $ruleFreq{$i}++;
            }
        }
        if ($datum =~ $patterns[3]) {   
            if (($integer ne "empty") && ($datum > $integer)) {
                $ruleFreq{3}++;
            }
            $integer = $datum;
        }
        #first regex makes sure its just letters second check is if its NOT prime third is if its a single char
        if ($datum =~ qr/^([a-zA-Z])\1+$/ and $datum !~ $patterns[4] and $datum !~ qr/^[a-zA-Z]$/) { 
            $ruleFreq{4}++;
        }
    }
}

# Sort the rule frequencies by value
# Found here: http://perldoc.perl.org/functions/sort.html
@sortedRuleFreq = sort { $ruleFreq{$b} <=> $ruleFreq{$a} } keys %ruleFreq;

# Print the results!
foreach (@sortedRuleFreq) {
    print $ruleNames[$_], ": ", $ruleFreq{$_}, "\n";
}
