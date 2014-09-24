#!/usr/bin/perl
#############################################################################
# File: process.pl
# Usage from command line:
#   perl process.pl < input.txt
#############################################################################
# Authors:
#    Steven Hudak,     hudak1@umbc.edu
#    Eric Hebert,      ehebert1@umbc.edu
#    Nikolaus Woehlke, woehlke1@umbc.edu
#    Matthew Henry,    henmatt1@umbc.edu
# Class:         CMSC 331 Fall 2014 section 04
# Project:       Assignment 2
# Date finished: September 23, 2014
#############################################################################

use warnings;
# Make perl unicode-aware so we can use things like \p{Greek}:
use utf8;
# Stop perl from complaining about mulit-byte output:
use open ':std', ':encoding(UTF-8)';


=head1 NAME

process.pl - print frequencies of patterns within a whitespace delimited file

=head1 SYNOPSIS

B<perl> B<process.pl> B<<> I<input.txt>

=head1 DESCRIPTION

 Given a valid UTF-8 encoded text file comprised of whitespace-delimited
 data, this program find the following things:
   1. Any datum starting with a Greek character and ending with a
      Cyrillic one.
   2. Any datum that contains a balanced set of square brackets.
   3. Any datum that contains at least two distinct double letters in a
      row.
   4. Any integer that is larger than the most recent integer seen.
   5. Any datum that is a same character repeated a prime number of times.
 Once all these data are extracted from the corpus, the program prints a
 list of the frequencies of these categories of datums, from most to
 least frequent.

=head1 REQUIRES

Perl v5.10.1 (Not tested with any prior versions).

=head1 AUTHOR

Steven Hudak, hudak1@umbc.edu;
Eric Hebert, ehebert1@umbc.edu;
Nikolaus Woehlke, woehlke1@umbc.edu;
Matthew Henry, henmatt1@umbc.edu;

=cut


######################
# Regular expressions:
######################

# The three basic patterns:
my @basicPatterns = (
    # Match datum beginning with a Greek letter and ending with a Cyrillic
    # letter:
    qr/^\p{Greek}\S*\p{Cyrillic}$/,
    
    # Match any datum containing balanced square brackets.
    # This one is confusing. The espaced brackets, '\[' or '\]' match actual
    # brackets in the string, while others, '[' or ']', are for character
    # classes:
    qr/[^\[]*\[[^\]]*\]\S*/,
    
    # Match any datum that contains at least two distinct double letters in a
    # row:
    qr/\S*(\p{L})\1(?!\1)(\p{L})\2\S*/,
);

# Matches a whole number with a single leading + or -:
$wholeNumber = qr/^[-+]?\d*\d$/;

# Match any datum that is a same character repeated a (NOT) prime number
# times.
# Derived from http://montreal.pm.org/tech/neil_kandalgaonkar.shtml
$notPrime = qr/^((\S)\2+?)\1+$/;

# Match all the same character:
$sameChar = qr/^(\S)\1+$/;


####################
# Other Useful Data:
####################

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


############
# Main loop:
############

# Process each line from the redirected input file:
while ($input = <STDIN>) {

    # Breaks it up into data chunks delimited by whitespace:
    @datums = split('\s+', $input);
    foreach my $datum (@datums) {
        # Capture basic patterns
        for ($i = 0; $i < 3; $i++) {
            if ($datum =~ $basicPatterns[$i]) {
                $ruleFreq{$i}++;
            }
        }
        if ($datum =~ $wholeNumber) {   
            if (($integer ne "empty") && ($datum > $integer)) {
                $ruleFreq{3}++;
            }
            $integer = $datum;
        }
        # First regex makes sure it's two or more of the same character.
        # Second check is if it's NOT not-prime (i.e. if it IS prime):
        if ($datum =~ $sameChar and $datum !~ $notPrime) { 
            $ruleFreq{4}++;
        }
    }
}


###################
# Final Processing:
###################

# Sort the rule frequencies by value
# Found here: http://perldoc.perl.org/functions/sort.html
@sortedRuleFreq = sort { $ruleFreq{$b} <=> $ruleFreq{$a} } keys %ruleFreq;

# Print the results!
foreach (@sortedRuleFreq) {
    print $ruleNames[$_], ": ", $ruleFreq{$_}, "\n";
}
