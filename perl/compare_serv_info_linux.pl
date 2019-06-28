#!/usr/bin/perl -w

use lib './perl/modules';
use XML::Simple;

open STDERR, ">> /dev/nul";  
$hostname =qx/hostname/ ;
$uname= qx/uname/ ;
$uname =~ s/\s+$//g;
$hostname =~ s/\s+$//g;
open(STDOUT,">$hostname.txt") || die ("open STDOUT failed");
$xml=new XML::Simple;
$ref=$xml->XMLin("output.xml") || die ("open output.xml failed");
if($uname =~ /Linux/){
print "Below are validation result of ",$hostname,"\n";
for my $type (sort keys %$ref){
  if ($type=~ /Interface/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
        if ($host=~ /$hostname/){
         $ip=$ref->{$type}->{$host}->{'IPAddress'};
         $ip=~ s/\"//g;
         #$inf=$ref->{$type}->{$host}->{'Interface'};
	     # $inf=~ s/\"//g;
         $netmask=$ref->{$type}->{$host}->{'Netmask'};
		 $netmask=~ s/\"//g;
         $cmd="/sbin/ifconfig";
		 @ipinfo=qx/$cmd/;
		 $valid=0;
		   for($i=0;$i<=$#ipinfo;$i++){
             if ($ipinfo[$i]=~ /($ip)/g){
               $nstate=$i+2;
			   $valid=1;
               print "IP address ",$1," is validated.\n";
                
               print "its status is: ",$1,"\n" if $ipinfo[$nstate]=~ /(UP\sBROADCAST\sRUNNING)/g;
			  }
           }
          print "IP address ",$ip," is not validated.\n" if $valid eq 0	
            }
        }
    }

  if ($type=~ /Memory/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
	    if ($host=~ /$hostname/){
		$memory=$ref->{$type}->{$host}->{'Memory'};
		$memory=~ s/\"//g;
                $cmd="/bin/grep MemTotal /proc/meminfo";
				$line=qx/$cmd/;
                $realmem=$1 if $line=~ /MemTotal:\s+(\S+)/g;
                $realmem= sprintf("%d",$realmem/(1000**2));
		if ($memory eq $realmem){print "Memory size is ",$memory,"  ---->Memory info pass","\n"}
                else{print "Memory size is ",$realmem,"  ---->Memory info fail","\n";
                     print "    it should be ",$memory," ---->Memory info fail","\n"}
		}
	}
  }
  if ($type=~ /OS/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
	    if ($host=~ /$hostname/){
		$os=$ref->{$type}->{$host}->{'OperatingSystem'};
		$os=~ s/\"//g;
                $cmd="/usr/bin/head -n 1 /etc/issue";
				$realos=qx/$cmd/;
                $realos=~ s/\(//g;
                $realos=~ s/\)//g;
                $realos=~ s/\s+$//g;
                print "The requested OS is ",$os,"\n";
                print "The real OS is ",$realos,"\n";
	    }
    }
}
  if ($type=~ /VU/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
	    if ($host=~ /$hostname/){
		$vu=$ref->{$type}->{$host}->{'VU'};
		$vu=~ s/\"//g;
                $cmd="/bin/grep processor /proc/cpuinfo" ;
				@cpuinfo=qx/$cmd/;
				$ncpu=@cpuinfo;
                $cmd="/bin/grep name /proc/cpuinfo";
				@model=qx/$cmd/;
                print "The requested VU is ",$vu,"\n";
                print "The real number of vCPU is ", $ncpu,"\n";
                print $model[0],"\n";
                print "-----------------------------------------------------------------------------------------------------------------","\n";
		        }  
	}
  }	
  if ($type=~ /NFS/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
	    if ($host=~ /$hostname/){
		$filer=$ref->{$type}->{$host}->{'FilerHostname'};
		$filer=~ s/\"//g;
		$size=$ref->{$type}->{$host}->{'Size'};
		$size=~ s/\"//g;
		$export=$ref->{$type}->{$host}->{'Export'};
		$export=~ s/\"//g;
		$mp=$ref->{$type}->{$host}->{'Mount'};
		$mp=~ s/\"//g;
		    if(defined $mp){
                $cmd="/bin/df -h $mp";
				$nfsinfo=qx/$cmd/;
                $realfiler=$1 while $nfsinfo=~ /(\S+):/g;
                $realexport=$1 while $nfsinfo=~ /:(\S+)/g;
                $realsize=$1 if $nfsinfo=~ /(\S+)[GM]\b/g;
                $realmp=$1 if $nfsinfo=~ /(\S+)$/g;
            if($filer eq $realfiler && $realsize <= $size * 1.05 && $realsize >= $size * 0.95 && $export eq $realexport && $mp eq $realmp)
                {print "Requested NFS info is ",$filer," ",$export," ",$size," ",$mp," ---->NFS info pass","\n";
			     print "Actual NFS info is ",$realfiler," ",$realexport," ",$realsize," ",$realmp," ---->NFS info pass","\n"}
                else{print "Requested NFS info is ",$filer," ",$export," ",$size," ",$mp," ---->NFS info fail","\n" ;
                print "Actual NFS info is ",$realfiler," ",$realexport," ",$realsize," ",$realmp," ---->NFS info fail","\n"}
				$nfsinfo="";
				$realfiler="";
				$realexport="";
				$realsize="";
				$realmp="";
			}
        }
    }
  }
} 
}
elsif( $uname=~/SunOS/){
print "Below are validation result of ",$hostname,"\n";
for my $type (sort keys %$ref){
  if ($type=~ /Interface/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
        if ($host=~ /$hostname/){
         $ip=$ref->{$type}->{$host}->{'IPAddress'};
         $ip=~ s/\"//g;
         #$inf=$ref->{$type}->{$host}->{'Interface'};
        # $inf=~ s/\"//g;
         $netmask=$ref->{$type}->{$host}->{'Netmask'};
		 $netmask=~ s/\"//g;
      	 $cmd="/sbin/ifconfig -a";
		 @ipinfo=qx/$cmd/;
		 $valid=0;
		   for($i=0;$i<=$#ipinfo;$i++){
             if ($ipinfo[$i]=~ /($ip)/g){
               $nstate=$i-1;
			   $valid=1;
               print "IP address ",$1," is validated.\n";
              
               print "its status is: ",$1,"\n" if $ipinfo[$nstate]=~ /(UP,BROADCAST,RUNNING)/g;
			  }
			}
          print "IP address ",$ip," is not validated.\n" if $valid eq 0		   
        }
    }
  }

  if ($type=~ /Memory/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
            if ($host=~ /$hostname/){
                $memory=$ref->{$type}->{$host}->{'Memory'};
                $memory=~ s/\"//g;
                $cmd="/usr/sbin/prtconf";
				$line=qx/$cmd/;
                $realmem=$1 if $line=~ /size:\s+(\d+)/g;
                $realmem= sprintf("%d",$realmem/1000);
                if ($memory eq $realmem){print "Memory size is ",$memory,"  ---->Memory info pass","\n"}
                else{print "Memory size is ",$realmem,"  ---->Memory info fail","\n";
                     print "    it should be ",$memory," ---->Memory info fail","\n"}
                }
        }
  }
  if ($type=~ /OS/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
            if ($host=~ /$hostname/){
                $os=$ref->{$type}->{$host}->{'OperatingSystem'};
                $os=~ s/\"//g;
                $cmd="/usr/bin/head -n 1 /etc/release";
				$realos=qx/$cmd/;
                $realos=~ s/\(//g;
                $realos=~ s/\)//g;
                $realos=~ s/\s+$//g;
                print "The requested OS is ",$os,"\n";
                print "The real OS is ",$realos,"\n";
            }
    }
}
  if ($type=~ /VU/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
            if ($host=~ /$hostname/){
                $vu=$ref->{$type}->{$host}->{'VU'};
                $vu=~ s/\"//g;
               	$cmd="/usr/sbin/psrinfo" ;
				@cpuinfo=qx/$cmd/;
				$ncpu=@cpuinfo;
                print "The requested VU is ",$vu,"\n";
                print "The real number of vCPU is ", $ncpu,"\n";
                
 print "-----------------------------------------------------------------------------------------------------------------","\n";
                }
        }
  }
  if ($type=~ /NFS/ ){
    print "-----------------------------------------------------------------------------------------------------------------","\n";
    for my $host (sort keys %{$ref->{$type}}){
            if ($host=~ /$hostname/){
                $filer=$ref->{$type}->{$host}->{'FilerHostname'};
                $filer=~ s/\"//g;
                $size=$ref->{$type}->{$host}->{'Size'};
                $size=~ s/\"//g;
                $export=$ref->{$type}->{$host}->{'Export'};
                $export=~ s/\"//g;
                $mp=$ref->{$type}->{$host}->{'Mount'};
                $mp=~ s/\"//g;
				if(defined $mp){
              	  $cmd="/bin/df -h $mp";
				  $nfsinfo=qx/$cmd/;
                  $realfiler=$1 while $nfsinfo=~ /(\S+):/g;
                  $realexport=$1 while $nfsinfo=~ /:(\S+)/g;
                  $realsize=$1 if $nfsinfo=~ /(\S+)[GM]\b/g;
                  $realmp=$1 if $nfsinfo=~ /(\S+)$/g;
                    if($filer eq $realfiler && $realsize <= $size * 1.05 && $realsize >= $size * 0.95 && $export eq $realexport && $mp eq $realmp)
                    {print "Requested NFS info is ",$filer," ",$export," ",$size," ",$mp," ---->NFS info pass","\n";
					 print "Actual NFS info is ",$realfiler," ",$realexport," ",$realsize," ",$realmp," ---->NFS info pass","\n"}
                    else{print "Requested NFS info is ",$filer," ",$export," ",$size," ",$mp," ---->NFS info fail","\n" ;
                    print "Actual NFS info is ",$realfiler," ",$realexport," ",$realsize," ",$realmp," ---->NFS info fail","\n"}
					$nfsinfo="";
					$realfiler="";
					$realexport="";
					$realsize="";
					$realmp="";
				}
            }
    }
  }
}
}
close(STDOUT);
close(STDERR);
