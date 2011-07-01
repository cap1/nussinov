#!/usr/bin/perl

use strict;
use warnings;

sub readFile 
{
  my $file = shift;
  open(DATA,'<',"$file") || die("can't open datafile: $!\n");
  my @data = <DATA>;
  chomp(@data);
  return join("",@data);
}

sub delta 
{
  my $i=shift;
  my $j=shift;
  if ((($i eq 'A') && ($j eq 'U')) || (($i eq 'U') && ( $i eq 'A')))
  {
    return 1;
  }
  if ((($i eq 'G') && ($j eq 'C')) || (($i eq 'C') && ( $i eq 'G')))
  {
    return 1;
  }
  if ((($i eq 'G') && ($j eq 'U')) || (($i eq 'U' ) && ($j eq 'G'))) 
  {
   return 1;
  }
  return 0;
}

sub do_call_0118999881999119725_3_gamma 
{
  my $field=shift;
  my $size=shift;
  my $sequence=shift;
  my $starti=0;
  my $maximum = 0;
  do 
  {
    for (my $i=$starti;$i<$size;$i++) 
    {
      #my $k=$size/2;
      my $j=$i+1;
      my $maximum = gamma($field,$i,$j);
      $field->[$i][$j] = $maximum;
    }
  }
  while ($starti++<$size);
}

sub gamma
{
  my $field = shift;
  my $i = shift;
  my $j = shift;
  my @results;
  my $max;
  push(@results,gamma($i+1,$j-1));
  push(@results,gamma($i+1,$j));
  push(@results,gamma($i,$j-1));
  $max = (sort(@results))[-1];     #[-1] ~ nimmt letztes element des arrays...
  
  
  return $max;
}

sub printField
{
  my $field=shift;
  my $size=shift;
  for (my $i=0;$i<$size;$i++)
  {
    for (my $j=0;$j<$size;$j++)
    {
      if (defined($field->[$i][$j]))
      {
        print($field->[$i][$j]," ");
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
  my $size = shift;
  for(my $i=0;$i<$size;$i++) 
   {
     for(my $j=0;$j<$size;$j++) 
     {
       if(($i==$j) || ($i==$j+1))
       {
         $field->[$i][$j] = 0;
       }
     }
  }
}

sub main 
{
  my $sequence;
  my @field;
  if (scalar(@ARGV)==0)
  {
    print("Error, filename needed\n");
  }
  else 
  {
    if (scalar(@ARGV)==1) 
    {
       print($sequence=&readFile($ARGV[0]),"\n");
       my $size=length($sequence);
       &initializeField(\@field,$size);
       &printField(\@field,$size);
    }
  }


}


&main;