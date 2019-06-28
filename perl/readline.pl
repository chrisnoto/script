use strict;
use warnings;
open(MYFILE,"d:\\FBVERITAS.txt") or die "can not open file :$!";
foreach my $line (<MYFILE>){
  chomp $line;
  if ($line =~/OS\sVersion/){print $line,"\n";}
  if ($line =~/Physical\sMemory/){print $line,"\n";}
  if ($line =~/CPU\sInfo/){print $line,"\n";}
  if( $line =~/Local\sFixed\sDisk/){
   my @diskline= split(/\s+/,$line);
   print $diskline[3], " ", sprintf("%d",$diskline[4]/(1024**3)),"\n";
       }
	if ( $line =~/interface/ ){
	my @infline= split(/"/,$line);
	print "\n","Interface ",$infline[1]," ";
	}
	if ( $line =~/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ )  {
    my @ipline= split(/:(\s)+/,$line);
	print $ipline[2], " ";
}	
}
close MYFILE;
