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
	my $j = shift;
	my $i = shift;
	if ((($i eq 'A') && ($j eq 'U')) || (($i eq 'U') && ($j eq 'A'))) {
		return 1;
	}
	if ((($i eq 'G') && ($j eq 'C')) || (($i eq 'C') && ($j eq 'G'))) {
		return 1;
	}
#	if ((($i eq 'G') && ($j eq 'U')) || (($i eq 'U') && ($j eq 'G'))) {
#		return 1;
#	}
	return 0;
}

sub fill_array {
	my $field    = shift;
	my $size     = shift;
	my $sequence = shift;

	for (my $j = 1 ; $j < $size ; $j++) {
		for (my $x = $j ; $x < $size ; $x++) {
			my $resultHash = &gamma($sequence, $field, $x, $x - $j);
			$field->[$x][ $x - $j ] = $resultHash;
			$field->[$x][ $x - $j ]{j}   = $x;
			$field->[$x][ $x - $j ]{i}   = $x-$j;
		}
	}
}

sub traceback {
	my $field = shift;
	my $size = shift;
	my $sequence = shift;
	my $j	= $size-1;
	my $i = 0;

	my $left = "";
	my $right = "";
	my @stack = ();

	push(@stack,$field->[$j][$i]);

	while (scalar(@stack) != 0) {
		my	$current = pop(@stack);
		
		next if ($current->{ptr} eq "n");
		print $current->{ptr} ."\n";

		if ($current->{ptr} eq "d") {
			$right = ")" .  $right;
			$left .= "(";
			push(@stack,$field->[$current->{j}-1][$current->{i}+1]);
		}
		elsif ($current->{ptr} eq "l") {
			$right = ".".$right;
			push(@stack,$field->[$current->{j}-1][$current->{i}]);
		}
		elsif ($current->{ptr} eq "u") {
			$left .= ".";
			push(@stack,$field->[$current->{j}][$current->{i}+1]);
		}
		elsif ($current->{ptr} eq "b") {
			push(@stack,$field->[$current->{k}+1][$current->{i}]);
			push(@stack,$field->[$current->{j}][$current->{k}]);
		}
	}
	print "\n\n$sequence\n$left$right\n";
	return 1;
}

sub gamma {
	my $sequence = shift;
	my $field    = shift;
	my $j        = shift;
	my $i        = shift;
	my @results;
	my $max;

	my %diag = (
		score => $field->[ $j - 1 ][ $i + 1 ]{score} + &delta(substr($sequence, $j, 1), substr($sequence, $i, 1)),
		ptr   => "d"
	);
	my %left = (score => $field->[ $j - 1 ][$i]{score}, ptr => "l");
	my %up = (score => $field->[$j][ $i + 1 ]{score}, ptr => "u");
	my %bifork = (score => 0, ptr => "b", k => 0);


	for (my $k = $i+1 ; $k < $j ; $k++) {
		my $kTmp = $field->[$k][$i]{score} + $field->[$j][$k+1]{score};
		if ($kTmp > $bifork{score}) {
			$bifork{score} = $kTmp;
			$bifork{k} = $k;
		}
	}
	push(@results, \%diag);
	push(@results, \%bifork);
	push(@results, \%up);
	push(@results, \%left);

	$max = (sort { $a->{score} <=> $b->{score} } (@results))[-1];
	return $max;
}

sub printField {
	my $field    = shift;
	my $size     = shift;
	my $sequence = shift;
	print("   ");
	for (my $j = 0 ; $j < $size ; $j++) {
		print(" " . substr($sequence, $j, 1) . " ");
	}
	print("\n");

	for (my $i = 0 ; $i < $size ; $i++) {
		print(" " . substr($sequence, $i, 1) . " ");
		for (my $j = 0 ; $j < $size ; $j++) {
			if (defined($field->[$j][$i]{ptr})) {
				print(" ", $field->[$j][$i]{ptr}, $field->[$j][$i]{score}, "");
			}
			elsif ($j < $i) {
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
				$field->[$j][$i]{ptr} = "n";	# none
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
			&fill_array(\@field, $size, $sequence);
			&printField(\@field, $size, $sequence);
			&traceback(\@field, $size, $sequence);
		}
	}

}

&main;
