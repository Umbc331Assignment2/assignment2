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

	# Matches Digits
	qr/^\-?\d*\d$/,

    # (Will be) match any datum that is a same character repeated prime number times
    # Derived from http://montreal.pm.org/tech/neil_kandalgaonkar.shtml
    qr/^(([a-zA-Z])\2+?)\1+$/
);

# Array of counters each element being a different rule triggered
my @rulefreq = (0,0,0,0,0);

#arrays to store values
my @rule1 = (); my @rule2 = (); my @rule3 = (); my @rule4 = (); my @rule5 = (); 
# Hashmap for storing the matched datums with their respective rule
my %matches = (	
				1 => \@rule1, 
				2 => \@rule2,
				3 => \@rule3,
				4 => \@rule4,
				5 => \@rule5,
			  						); #key then value respectively

# Scalar for storing most recent integer seen
my $integer = "empty";

# Process each line from the redirected input file:
while ($input = <STDIN>) {

    # Breaks it up into data chunks delimited by whitespace:
    @datums = split('\s+', $input);
    foreach my $datum (@datums) {

        # Capture basic patterns
        if ($datum =~ $patterns[0]) {
			push($matches{1},$datum);
            $rulefreq[0]++;
        }
		if ($datum =~ $patterns[1]) {
			push($matches{2},$datum);
            $rulefreq[1]++;
        }
		if ($datum =~ $patterns[2]) {
			push($matches{3},$datum);
            $rulefreq[2]++;
        }
		if ($datum =~ $patterns[3]) {	#TODO dont understand this yet i may of implemented wrong
			
			if (($integer ne "empty") && ($datum > $integer)) {
				push($matches{4},$datum);
				$rulefreq[3]++;
            }
            $integer = $datum;
        }
		#if ($datum =~ @pattern[4]) {
		#	push($matches{'rule 5:'},$datum);
        #    @rulefreq4]++;
        #}


    }
}

# Sort the matches by value
# Found here: http://perldoc.perl.org/functions/sort.html
#@sortedMatches = sort { $matches{$b} <=> $matches{$a} } keys %matches;

#backslash passes by refference
sub printsorted(%matches, @rulefreq) {
	$biggestval = 0;
	$biggestindex = 0;
	for($i=0; $i < scalar @rulefreq ; $i++) {
		if($rulefreq[$i] >= $biggestval) {
			$biggestindex = $i;
		}
	}#end for
	print $matches{$biggestindex};					#prints rule's data collected
	delete $matches{$biggestindex};				#removes rule we just printed
	delete $rulefreq[$biggestindex];				#keeps both structures same size
}#end printsorted

# Print each match:
while (!keys %matches) {
	printsorted(\%matches, @rulefreq);
}




