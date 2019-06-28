use strict;
use warnings;

my $f1 = '/home/sam/1.txt';
my $f2 = '/home/sam/2.txt';
my $outfile = '/home/sam/4.txt';
my %results = ();

open FILE1, "$f1" or die "Could not open file: $! \n";
while(my $line = <FILE1>){
   $results{$line}=1;
}

#print keys(%results),"\n";
#   print values(%results),"\n";
close(FILE1);

open FILE2, "$f2" or die "Could not open file: $! \n";
while(my $line =<FILE2>) {
   $results{$line}++;
}

#print keys(%results),"\n";
#   print values(%results),"\n";
close(FILE2);


open (OUTFILE, ">$outfile") or die "Cannot open $outfile for writing \n";
foreach my $line (keys %results) {
   # chop($line);
   print OUTFILE "Info pass:", $line,if  $results{$line} > 1;
}
close OUTFILE;
