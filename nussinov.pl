#!/usr/bin/perl

use strict;
use warnings;

sub readFile
{
	my $file = shift;
	open(DATA, '<', "$file") || die("can't open datafile: $!\n");
	my @data = <DATA>;
	chomp(@data);
	return uc(join("", @data));
}

sub delta
{
	my $j = shift;
	my $i = shift;
	if ((($i eq 'A') && ($j eq 'U')) || (($j eq 'U') && ($i eq 'A')))
	{
		return 1;
	}
	if ((($i eq 'G') && ($j eq 'C')) || (($j eq 'C') && ($i eq 'G')))
	{
		return 1;
	}
	if ((($i eq 'G') && ($j eq 'U')) || (($j eq 'U') && ($i eq 'G')))
	{
		return 1;
	}
	return 0;
}


sub fill_array
{
	my $field = shift;
	my $size  = shift;
	my $sequence = shift;

	for (my $j = 1 ; $j< $size ; $j++)
	{	
		for (my $x = $j ; $x < $size; $x++)
		{
			$field->[$x][$x-$j]{score} = &gamma($sequence,$field,$x,$x-$j);
		}
	}
}



sub gamma
{
	my $sequence = shift;
	my $field = shift;
	my $j     = shift;
	my $i     = shift;
	my @results;
	my $max=0;
	push(@results, $field->[$j - 1][$i + 1]{score}  + &delta(substr($sequence,$j,1),substr($sequence,$i,1)));
	push(@results, $field->[$j - 1][$i    ]{score});
	push(@results, $field->[$j    ][$i + 1]{score});

	my $kmax=0;
	for (my $k=$j; $k<$i; $k++)
	{
			
	}


	$max = (sort(@results))[-1];    

	return $max;
}

sub printField
{
	my $field = shift;
	my $size  = shift;
	my $sequence = shift;
	print("   ");
	for (my $j = 0 ; $j< $size ; $j++)
	{
		print(" " .substr($sequence,$j,1) . " ");
	}
	print("\n");

	for (my $i = 0 ; $i< $size ; $i++)
	{ 
		print(" " . substr($sequence,$i,1) . " ");
		for (my $j = 0 ; $j < $size ; $j++)
		{
			if (defined($field->[$j][$i]{score}))
			{
				print(" ",$field->[$j][$i]{score}, " ");
			}
			elsif($j<$i)
			{
				print("   ");
			}
			else
			{
				print(" . ");
			}
		}
		print("\n");
	}
}

sub initializeField
{
	my $field = shift;
	my $size  = shift;
	for (my $j = 0 ; $j < $size ; $j++)
	{
		for (my $i = 0 ; $i < $size ; $i++)
		{
			if (($i == $j) || ($i == $j + 1))
			{
				$field->[$j][$i]{score} = 0;
			}
		}
	}
}

sub main
{
	my $sequence;
	my @field;
	if (scalar(@ARGV) == 0)
	{
		print("Error, filename needed\n");
	}
	else
	{
		if (scalar(@ARGV) == 1)
		{
			print($sequence= &readFile($ARGV[0]), "\n");
			my $size = length($sequence);
			&initializeField(\@field, $size);
		        &fill_array(\@field, $size,$sequence);
			&printField(\@field, $size,$sequence);
		}
	}

}

&main;
