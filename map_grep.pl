#!/usr/bin/perl -w
my @array1=("blue","red","black","pink","orange");
print scalar @array1,"\n";
print join " ",grep { length $_ >=4 } @array1;
print "\n";
my @array2=(28,58,54,675,7);
print join " ", sort @array2;
print "\n";
print join " ", sort { $a cmp $b } @array2;
print "\n";
print join " ", sort { $a <=> $b } @array2;
print "\n";
print join " ",map { $_=$_*1024} @array2;
print "\n";
