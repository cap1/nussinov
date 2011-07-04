#!/usr/bin/perl

use strict;
use warnings;

sub readFile {
	my $file = shift;
	open(DATA, '<', "$file") || die("can't open datafile: $!\n");
	my @data = <DATA>;
	chomp(@data);
	return uc(join("", @data));
}

sub delta {
	my $i = shift;
	my $j = shift;
		print "$i$j\n";
	if ((($i eq 'A') && ($j eq 'U')) || (($i eq 'U') && ($j eq 'A'))) {
		return 1;
	}
	if ((($i eq 'G') && ($j eq 'C')) || (($i eq 'C') && ($j eq 'G'))) {
		return 1;
	}
	if ((($i eq 'G') && ($j eq 'U')) || (($i eq 'U') && ($j eq 'G'))) {
		return 1;
	}
	return 0;
}

sub fill_array {
	my $sequence = shift;
	my $field = shift;
	my $size  = shift;
	for (my $j = 1 ; $j < $size ; $j++) {
		for (my $x = $j ; $x < $size ; $x++) {
			$field->[$x][$x-$j]{score} = &gamma($sequence,$field,$x,$x-$j);
		}
	}
}


sub gamma {
	my $sequence = shift;
	my $field = shift;
	my $j     = shift;
	my $i     = shift;
	my @results;

	
	push(@results, $field->[$j-1][$i+1]{score} + &delta(substr($sequence,$i,1),substr($sequence,$j,1)));
	push(@results, $field->[$j-1][$i]{score});
	push(@results,	$field->[$j][$i+1]{score});
	
	my $max = (sort(@results))[-1];    #[-1] ~ nimmt letztes element des arrays...

	return $max;
}

sub printField {
	my $field = shift;
	my $size  = shift;
	for (my $j = 0 ; $j < $size ; $j++) {
		for (my $i = 0 ; $i < $size ; $i++) {
			if (defined($field->[$i][$j]{score})) {
				print(" " . $field->[$i][$j]{score} . " ");
			}
			elsif ($i<$j) {
				print("   ");
			}
			else {
				print(" . ");
			}
		}
		print("\n");
	}
}

sub initializeField {
	my $field = shift;
	my $size  = shift;
	for (my $j = 0 ; $j < $size ; $j++) {
		for (my $i = 0 ; $i < $size ; $i++) {
			if (($i == $j) || ($i == $j + 1)) {
				$field->[$j][$i]{score} = 0;
			}
		}
	}
}

sub main {
	my $sequence;
	my @field;
	if (scalar(@ARGV) == 0) {
		print("Error, filename needed\n");
	}
	else {
		if (scalar(@ARGV) == 1) {
			print($sequence= &readFile($ARGV[0]), "\n");
			my $size = length($sequence);
			&initializeField(\@field, $size);
			&fill_array($sequence,\@field,$size);
			&printField(\@field, $size);
		}
	}

}

&main;
