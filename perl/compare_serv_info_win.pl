use XML::Simple;
use Data::Dumper;
use Win32;
use Win32::OLE;
my $hostname = Win32::NodeName();
my $wmi = Win32::OLE->GetObject("WinMgmts://./root/cimv2") or die "Failed: GetObject\n";
my $ncpu=0;

$xml=new XML::Simple;
$ref=$xml->XMLin("c:\\inc302720\\output.xml");
#print Dumper($ref);
#print $ref->{'Interface'}->{'vmwmagweb01-tst'}->{'IPAddress'}, "\n";
for my $type (sort keys %$ref){
  if ($type=~ /Interface/ ){
    for my $host (sort keys %{$ref->{$type}}){
      #print $host,"\n";
        if ($host=~ /$hostname/){
         $ip=$ref->{$type}->{$host}->{'IPAddress'};
         $ip=~ s/\"//g;
         $inf=$ref->{$type}->{$host}->{'Interface'};
		 $inf=~ s/\"//g;
         #$netmask=$ref->{$type}->{$host}->{'Netmask'};
         #$subnet=$ref->{$type}->{$host}->{'Subnet'};

         $list = $wmi->ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled = true" );
           for $v (Win32::OLE::in $list) {
         	 $ipaddr=$v->IPAddress;
	           if ($ip eq $$ipaddr[0]){print "The IP address of ",$inf," is ",$ip,"  validated.","\n" }
            }
        }
    }

  }
  if ($type=~ /Memory/ ){
    for my $host (sort keys %{$ref->{$type}}){
	#  print $host,"\n";
	    if ($host=~ /$hostname/){
		$memory=$ref->{$type}->{$host}->{'Memory'};
		$memory=~ s/\"//g;
		$list = $wmi->InstancesOf("Win32_PhysicalMemory") or die "Failed: InstancesOf\n";
          foreach $v (Win32::OLE::in $list){
          $mem= $mem + $v->Capacity;
          }
        $realmem = sprintf("%d",$mem/(1024**3)); 
		if ($memory eq $realmem){print "Memory size is ",$memory,"  validated.","\n"}
		}
	}
  }
  if ($type=~ /OS/ ){
    for my $host (sort keys %{$ref->{$type}}){
	#  print $host,"\n";
	    if ($host=~ /$hostname/){
		$os=$ref->{$type}->{$host}->{'OperatingSystem'};
		$os=~ s/\"//g;
		$list = $wmi->InstancesOf("Win32_OperatingSystem") or die "Failed: InstancesOf\n";
          foreach $v (Win32::OLE::in $list){
	      print "Requested OS type is ",$os,"\n";
          print "Real OS type is  ";
	      print $v->Caption, "\n";
		  }
	    }
    }
}
  if ($type=~ /VU/ ){
    for my $host (sort keys %{$ref->{$type}}){
	#  print $host,"\n";
	    if ($host=~ /$hostname/){
		$vu=$ref->{$type}->{$host}->{'VU'};
		$vu=~ s/\"//g;
        $list = $wmi->ExecQuery("Select * from Win32_Processor where Status='OK'" );
          foreach $v (Win32::OLE::in $list){
		  $ncpu=$ncpu+1
		  }
		}  
	}
  }	
  if ($type=~ /Storage/ ){
    for my $host (sort keys %{$ref->{$type}}){
	#  print $host,"\n";
	    if ($host=~ /$hostname/){
		$stype=$ref->{$type}->{$host}->{'StorageType'};
		$stype=~ s/\"//g;
		$size=$ref->{$type}->{$host}->{'Size'};
		$size=~ s/\"//g;
		$storage=$ref->{$type}->{$host}->{'Storage'};
		$storage=~ s/\"//g;
		$mp=$ref->{$type}->{$host}->{'Mountpoint'};
		$mp=~ s/\"//g;
	#	print $mp,$size,"\n";
		$list = $wmi->ExecQuery("Select * from Win32_LogicalDisk " );
		  for $v (Win32::OLE::in $list) {
            if ($mp eq $v->Name){
			 $realsize=$v->Size ;
			 $realsize = sprintf("%d",$realsize/(1024**3));
			   if ($size eq $realsize){print "The size of ",$mp," is ",$size,"GB","  validated.","\n" }
            }
		  }
        }
    }
  }
} 
print "The requested VU is ",$vu,"\n";
print "Real number of CPU is ",$ncpu,"\n";