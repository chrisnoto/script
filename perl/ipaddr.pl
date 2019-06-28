use strict;
use warnings;
use Win32;

use Win32::API;
  
use Socket;  
use Sys::Hostname;  
my $host = hostname;#output the host name;  
print "Host name: ",$host,"\n";  
my $name = gethostbyname($host);  
my $ip_addr = inet_ntoa($name);  
print $ip_addr,"\n"; 
