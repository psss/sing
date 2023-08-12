#!/usr/bin/perl

if ($#ARGV < 0) { die "musis dat parametr!"; }
for ($i = 1; $i < $ARGV[0]; $i += 8) {
  print ',' if $i != 1;
  print $i, ',', $i+1, ',', $i+4, ',', $i+5, ',', $i+2, ',', $i+3, ',', $i+6, ',', $i+7; 
}
