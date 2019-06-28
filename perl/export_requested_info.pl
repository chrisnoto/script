# SCRIPT: export_requested_info.pl
# AUTHOR: Sam Chen
# DATE: 01/12/2012
# PLATFORM: Windows
# PURPOSE: It can read multiple HCE Landscape/IP/NFS templates and 
#          export the needed cells(Interface name/IP/Memory/Filer name/volume name/mount point/etc)  to file "output.txt".
# USAGE example: c:\perl\bin\perl.exe export_requested_info.pl "d:\inc302720"
#
# Note:
# The script can only deal with excel 97-2003 for now. 
# The output should be copied to each new server built as input,then execute compare_serv_info.sh
# on each server to generate final validation output.
#       
use strict;
use warnings;
use Spreadsheet::ParseExcel;

open(STDOUT, ">output.txt") || die ("open STDOUT failed") ;

my $dir_name = $ARGV[0];
opendir(DIR,   "$dir_name")   ||   die   "Can 't   open   directory   $dir_name "; 
my @dots   =   readdir(DIR); 

foreach  my $file (@dots){ 

if($file =~ /Landscape/) {&export_landscape($dir_name.'\\'.$file);print "\n";}
elsif($file =~ /IP-Plan/){&export_IP_Plan($dir_name.'\\'.$file);print "\n";}
elsif($file =~ /NFS_Plan/){&export_NFS_Plan($dir_name.'\\'.$file);print "\n";}

} 

closedir  DIR;
close(STDOUT);

sub export_landscape{                                            # extract Memory and OS Type from Landscape HCE templates
my $oExcel = Spreadsheet::ParseExcel->new;
my $oBook = $oExcel->Parse($_[0]);
my ($iR, $iC, $oWkS, $oWkC);
$oWkS = $oBook->{Worksheet}[4];
my ($rowbegin_host, $rowend_host, $rowbegin_storage);
my ($hostn,$mem,$ostype);
for($iR = $oWkS->{MinRow} ; 
                 defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
                  $oWkC = $oWkS->{Cells}[$iR][0] ;
				  if( defined $oWkC->{Val} && $oWkC->{Val} eq "Hostname"){ $rowbegin_host = $iR+1;}
				  elsif( defined $oWkC->{Val} &&  $oWkC->{Val} eq "Note 1: see VU Reference Document"){$rowend_host = $iR-1;}
				  elsif( defined $oWkC->{Val} &&  $oWkC->{Val} eq "Storage for Hostname"){$rowbegin_storage = $iR+1;}
}

for($iR = $rowbegin_host ; 
                 defined $rowend_host && $iR <= $rowend_host ; $iR++) {

				$hostn = $oWkS->{Cells}[$iR][0] ;
				$mem = $oWkS->{Cells}[$iR][2] ;
				$ostype = $oWkS->{Cells}[$iR][4] ;
                if( not defined $hostn->{Val} or $hostn->{Val} eq ''){last;}
				print STDOUT "OS_type ",$hostn->Value," ",$ostype->Value,"\n", if( $hostn && $ostype);
				print STDOUT "Memory ",$hostn->Value," ",$mem->Value,"\n", if( $hostn && $mem);
            
		print "\n";
		
        }

#there:                                                   #extract NFS info from section III in Landscape HCE templates.
#for($iR = $rowbegin_storage ;                             # This part is discarded as the information extracted from NFS templates are more detailed.
#                 defined $oWkS->{MaxRow} && $iR < $oWkS->{MaxRow}; $iR++) {
#            for($iC = $oWkS->{MinCol} ;
#                             $iC <= 3 ; $iC++) {
#                $oWkC = $oWkS->{Cells}[$iR][$iC];
#				if($oWkC->{Val} eq ''){last there;}
#				print  STDOUT $oWkC->Value, " " if($oWkC)  ;  # Formatted Value
		  
#           }
#			print "\n";
#       }
}

sub export_IP_Plan{                                                     # extract IP info from IP-Plan templates
my $oExcel = Spreadsheet::ParseExcel->new;
my $oBook = $oExcel->Parse($_[0]);
my ($iR, $iC, $oWkS, $oWkC);
$oWkS = $oBook->{Worksheet}[1];
my ($rowbegin,$server,$ifname,$ipaddr,$subnet,$netmask);
for($iR = $oWkS->{MinRow} ; 
                 defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
                  $oWkC = $oWkS->{Cells}[$iR][1] ;
				  if( defined $oWkC->{Val} && $oWkC->{Val} eq "Interface Name"){ $rowbegin = $iR+1;}
				 }

for( $iR = $rowbegin; 
                 defined $oWkS->{MaxRow} && $iR < $oWkS->{MaxRow}; $iR++) {
				$server = $oWkS->{Cells}[12][1];
				$ifname = $oWkS->{Cells}[$iR][3] ;
				$ipaddr = $oWkS->{Cells}[$iR][4] ;
				$subnet  = $oWkS->{Cells}[$iR][5] ;
				$netmask = $oWkS->{Cells}[$iR][6] ;
			    if( not defined $ifname->{Val} or $ifname->{Val} eq ''){last;}
				print  STDOUT "Interface ",$server->Value, " ",$ifname->Value," ",$ipaddr->Value," ",$subnet->Value," ",$netmask->Value, if( $ifname && $ipaddr && $subnet && $netmask); 
				print "\n";
        }
				 
}
sub export_NFS_Plan{                                                # extract NFS info from NFS-Plan templates
my $oExcel = Spreadsheet::ParseExcel->new;
my $oBook = $oExcel->Parse($_[0]);
my ($iR, $iC, $oWkS, $oWkC);
$oWkS = $oBook->{Worksheet}[3];
my ($rowbegin,$host,$filername, $nfssize, $exportpath, $mountpoint, $nfsoption);
for($iR = $oWkS->{MinRow} ; 
                 defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
                  $oWkC = $oWkS->{Cells}[$iR][1];
				  if( defined $oWkC->{Val} && $oWkC->{Val} eq "Filer Hostname"){ $rowbegin = $iR+1;}
				 }

for( $iR = $rowbegin; 
                 defined $oWkS->{MaxRow} && $iR < $oWkS->{MaxRow}; $iR++) {
         		$host = $oWkS->{Cells}[13][2];
				$filername = $oWkS->{Cells}[$iR][1] ;
				$nfssize = $oWkS->{Cells}[$iR][8] ;
				$exportpath  = $oWkS->{Cells}[$iR][10] ;
				$mountpoint = $oWkS->{Cells}[$iR][15] ;
				$nfsoption = $oWkS->{Cells}[$iR][16] ;
				if( not defined $filername->{Val} or $filername->{Val} eq '' ){last ;}
				print STDOUT "NFS ",$host->Value," ",$filername->Value," ", $nfssize->Value," ", $exportpath->Value," ", $mountpoint->Value, " ",$nfsoption->Value,if( $filername &&  $nfssize &&  $exportpath && $mountpoint && $nfsoption);
             	print "\n";
        }

}

