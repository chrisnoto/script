use Win32;
use Win32::OLE;
my $wmi = Win32::OLE->GetObject("WinMgmts://./root/cimv2") or die "Failed: GetObject\n";
my $list, my $v; my $mem=0;
print Win32::NodeName();
$list = $wmi->InstancesOf("Win32_Processor") or die "Failed: InstancesOf\n";
foreach $v (Win32::OLE::in $list){
      print "CPU:\n";
	  print "\t", $v->{Name}, "\n";
	  print "\t", $v->{Caption}, "\n";
}
$list = $wmi->InstancesOf("Win32_PhysicalMemory") or die "Failed: InstancesOf\n";
foreach $v (Win32::OLE::in $list){
      $mem= $mem+$v->Capacity;
}
      print "Memory size(G): ", sprintf("%4.1f",$mem/(1024**3)),"\n";
	  
$list = $wmi->InstancesOf("Win32_ComputerSystem") or die "Failed: InstancesOf\n";
foreach $v (Win32::OLE::in $list){
    print "Total memory:\n";
	print "\t", sprintf("%4.1f",$v->{TotalPhysicalMemory}/(1024**3)), "\n";
}

$list = $wmi->InstancesOf("Win32_OperatingSystem") or die "Failed: InstancesOf\n";
foreach $v (Win32::OLE::in $list){
    print "OS:\n";
	print "\t", $v->{Name}, "\n";
}

$list = $wmi->ExecQuery("Select * from Win32_LogicalDisk where Size > 0");
for my $v (Win32::OLE::in $list) {
    print "DeviceID: ", $v->DeviceID,"\n";
    print "FileSystem: ", $v->FileSystem        ,"\n";
    print "FreeSpace(G): ", sprintf("%d",$v->FreeSpace/(1024**3)),"\n";
    print "Name: ", $v->Name,"\n";
    print "Size(G): ", sprintf("%d",$v->Size/(1024**3)),"\n";
    print "\n";
}

$list = $wmi->ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled = true");
for my $v (Win32::OLE::in $list) {
    print "NetConnectionID: ", $v->NetConnectionID,"\n";
	my $ip=$v->IPAddress;
	my $gw=$v->DefaultIPGateway;
	my $subnet=$v->IPSubnet;
	print "IPAddress: ",$$ip[0],"\n";
	print "DefaultIPGateway: ", $$gw[0],"\n";
	print "Netmask: ", $$subnet[0],"\n";
    print "\n";
}
 


0;
