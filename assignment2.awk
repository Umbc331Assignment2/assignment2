#!/usr/bin/awk -f
BEGIN {print "HELLO"}
	{	for (i=1;i<NF;i++)	#loops through each datum
		if( $i ~ /j/)			#evaluates regular expression
			remember[i] = $i	#if true remember datum		
	}
END	{checkarray(remember)}

function frequency(arrayofjunk)
{
	print "Derp"
}

function checkarray(a)	#see whats in array
{
	for(i in a)
		print a[i]
}
