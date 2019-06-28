use strict;
use warnings;
use Win32;
use Win32::OLE;
my $hostname = Win32::NodeName();
my $wmi = Win32::OLE->GetObject("WinMgmts://./root/cimv2") or die "Failed: GetObject\n";
my ($list,$ip,$v,$realmem); 
my (@interface,@memory,@os,@realos);
my $mem=0;
open(MYFILE,"d:\\output.txt") or die "can not open file :$!";
foreach my $line (<MYFILE>){
  chomp $line;
if (defined $line && $line =~/$hostname/){
  if ($line =~/Interface/){
  @interface = split(/\s+/,$line);
  $list = $wmi->ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled = true" );
    for $v (Win32::OLE::in $list) {
   	$ip=$v->IPAddress;
	if ($interface[3] eq $$ip[0]){print "$line","--------------> Interface info pass","\n" }
	#else {print "$line","--------------> Interface info fail","\n" }
        }
    }
  elsif ($line =~/OS_type/){
  @os = split(/\s+/, $line);
  $list = $wmi->InstancesOf("Win32_OperatingSystem") or die "Failed: InstancesOf\n";
    foreach $v (Win32::OLE::in $list){
	print "Requested OS type is: ","$os[2] ","$os[3] ","$os[4] ","\n";
    print "Real OS type is:  ";
	print $v->Caption, "\n";
}
  
  }
  elsif ($line =~/Memory/){
  @memory = split(/\s+/,$line);
  $list = $wmi->InstancesOf("Win32_PhysicalMemory") or die "Failed: InstancesOf\n";
    foreach $v (Win32::OLE::in $list){
     $mem= $mem + $v->Capacity;
     }
    $realmem = sprintf("%d",$mem/(1024**3)); 
	if ( $memory[2] eq $realmem){print "$line","--------------> Memory info pass","\n"}
	else {print "$line","--------------> Memory info fail","\n"}
	$mem=0;
    }
  }
}
close MYFILE;

