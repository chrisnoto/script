#!/usr/bin/perl
use strict;
#use warnings;


#############################################
## To check SUDO against standard ISEC
##
## Author: Henry Molina
##
## V1 07/10/10 hmolina Built basic code
## V2 12/10/10 hmolina Fixed log file check bug
###########################################

my $version="2.0";
my $SUDOERS="/etc/sudoers";
my $RESULT_OUTPUT="/tmp/";
my $RESULT_FILE_NAME="";

my $DAY = `date +%d`;
my $MONTH = `date +%b`;
my $YEAR = `date +%Y`;
chomp($DAY);
chomp($MONTH);
chomp($YEAR);

my $HOSTNAME=`hostname`;
chomp($HOSTNAME);

my $FILE_NAME = ${HOSTNAME}."_SUDO_SHC_".$DAY."_".$MONTH."_".$YEAR.".csv";

open ( OUTPUT_FILE , "> ${RESULT_OUTPUT}${FILE_NAME}" ) || die ("Cannot open ${RESULT_OUTPUT}${FILE_NAME}" );


sub print_usage()
{
	print "\n";
	print "SUDOER CHECKER Version: ".${version}."\n";
	print "\n";
	print "Purpose: Produces a CSV with the compliance posture of this machine against\n";
	print "the SUDO Tech Spec for the EBS account.\n";
	print "\n";
	print "Usage Instructions:\n";
	print "./sudo_shc_ebs_isev4_v1.pl [-s sudoer_file]\n";
	print "\n";
	print "Note: Run as root or a priveleged user. Sudoers has limited read access by default\n";
	print "\n";
	print "FLAGS\n";
	print "-s <sudoers_file> : location of where the sudoers file exists. Default: /etc/sudoers\n";
	print "-h                : print this help menu\n";
	print "Developed by: Henry Molina (hmolina\@au1.xxx.com)\n";
}


my $skip=0;
foreach my $pos ( 0 .. $#ARGV){
	
	if ( $skip == 1 ) {
		$skip=0;
		next;
	}
	
	my $flag = $ARGV[$pos];
	if ( $flag =~ m/-s/) {
			if ( $pos == $#ARGV ){
				print STDERR "Error aborting: Flag $flag specified without a value.\n";
				print STDERR "/n";
				print_usage();
				exit 2;
			}
			$SUDOERS=$ARGV[$pos+1];
			$skip=1;

	}elsif ( $flag =~ m/-h/) {
		print_usage();
		exit 1;
	}else{
		print STDERR "Error aborting: Unrecognised flag $flag.\n";
		exit 2;
	}
}

$HOSTNAME=clear_empty_spaces($HOSTNAME);
my $START_TIME=`date`;

my $PASSWD_FILE="/etc/passwd";
my $GROUP_FILE="/etc/group";
my $OUTPUT_DIR="/tmp";

my @SUDOERS_FILE_LINES = ();

my %HOST_ALIAS_LIST = ();
my %RUNAS_ALIAS_LIST = ();
my %USER_ALIAS_LIST = ();
my %CMD_ALIAS_LIST = ();

my %PASSWORD_FILE_USERS = ();
my %PASSWORD_FILE_UIDS = ();
my %GROUP_FILE_GROUPS = ();

my @userviolations = ();
my @groupviolations = ();
my @uidviolations = ();
my @netgroupviolations = ();
my @nonunixgroupviolations = ();

my @defaultSettings = ();

my @OSR_OWNERS=();
my @OSR_GROUPS=();
my $OS_NAME = `uname -s`;

if ( $OS_NAME =~ m/^\s*AIX\s*/i ){
	@OSR_OWNERS=("root","daemon","bin","sys","adm","uucp","nuucp","lpd","imnadm","ipsec","ldap","lp","snapp","invscout");
	@OSR_GROUPS=("system","security","bin","sys","adm","uucp","mail","printq","cron","audit","shutdown","ecs","imnadm","ipsec","ldap","lp","haemrm","hacmp","pconsole");	
}elsif ( $OS_NAME =~ m/^\s*Linux\s*/i ){
	@OSR_OWNERS=("root");
	@OSR_GROUPS=("root");
}elsif ( $OS_NAME =~ m/^\s*SunOS\s*/i ){
	@OSR_OWNERS=("root","daemon","bin","sys","adm","uucp","nuucp","smmsp","listen","lp","svctag","imnadm","sms-svc");
	@OSR_GROUPS=("root","uucp","daemon","other","mail","sysadmin","bin","tty","smmsp","sys","lp","nobody","adm","nuucp","imnadm","sms");
}elsif ( $OS_NAME =~ m/^\s*HP-UX\s*/i ){
	@OSR_OWNERS=("root","daemon","bin","sys","adm","uucp","nuucp","lp","hpdb","imnadm","cimsrvr");
	@OSR_GROUPS=("root","adm","tty","other","daemon","nuucp","bin","mail","nogroup","sys","lp","imnadm");
}else{
	print STDERR "Unsupported version of OS \" $OS_NAME \" for this version of the script.\n";
	exit 2;
}

#Cache owners
my %OSR_OWNER_LOOKUP = ();
foreach (@OSR_OWNERS){
	$OSR_OWNER_LOOKUP { $_ } = 1;
}

#Cache groups
my %OSR_GROUP_LOOKUP = ();
foreach (@OSR_GROUPS){
	$OSR_GROUP_LOOKUP { $_ } = 1;
}





sub clear_empty_spaces
{
	my $input = $_[0];
	$input =~ s/^\s+//;
	$input =~ s/\s+$//;
	return $input;
}

sub remove_leading_spaces
{
	my $input = $_[0];
	$input =~ s/^\s+//;
	return $input;

}

sub cache_passwd_file(){
	open (PASSWD_FILE, "< ${PASSWD_FILE}") || die ( "Unable to open the file ".$PASSWD_FILE."\n") ;
	chomp ( my @PASSWD_FILE_LINES = <PASSWD_FILE> ) ;
		foreach my $entry ( @PASSWD_FILE_LINES ) {
			my $username = (split ( /:/,$entry))[0];
			my $userid = (split ( /:/,$entry))[2];
			$PASSWORD_FILE_USERS { $username } = $entry;
			$PASSWORD_FILE_UIDS { $userid } = $entry;
		}
	close ( PASSWD_FILE ) ;	
}

sub cache_group_file(){
	open (GROUP_FILE, "< ${GROUP_FILE}") || die ( "Unable to open the file ".$GROUP_FILE."\n") ;
	chomp ( my @GROUP_FILE_LINES = <GROUP_FILE> ) ;
		foreach my $entry ( @GROUP_FILE_LINES ) {
			my $groupname = (split ( /:/,$entry))[0];
			$GROUP_FILE_GROUPS { $groupname } = $entry;
		}
	close ( GROUP_FILE ) ;
}

sub cache_sudoer_file(){
	
	open (SUDOERS_FILE, "< ${SUDOERS}")  || die ( "Unable to open the file ".$SUDOERS."\n") ;
	chomp ( @SUDOERS_FILE_LINES = <SUDOERS_FILE> ) ;
	close ( SUDOERS_FILE ) ;
	
	#cache_sudoer_aliases();
}

sub check_logfile_settings(){

	my $containsNotLogfile=0;
	foreach my $line (@defaultSettings){
		if ($line =~ m/.*!logfile.*/){
			${containsNotLogfile}=1;
			print OUTPUT_FILE "\"${HOSTNAME}\",\"1.2 Logging\",\"Must sudoers file must not contain !logfile\",\"File ${SUDOERS} contains !logfile\",VIOLATION\n";
		}
	}

	if ( !${containsNotLogfile} ){
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.2 Logging\",\"Must sudoers file must not contain !logfile\",\"File ${SUDOERS} does not contain !logfile\",COMPLIANT\n";
	}

	my $logFileLocation="notused";
	foreach my $line (@defaultSettings){
		if ($line =~ m/.*logfile=.*/){
			$logFileLocation=(split(/logfile\s*=/,$line))[1];
			$logFileLocation=(split(/,/,$logFileLocation))[0];
			$logFileLocation=clear_empty_spaces($logFileLocation);
		}
	}
	
	if ( $logFileLocation eq "notused" ){
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.2 Logging\",\"If logfile used, it must exist\",\"Log file is not used, provide evidence that OS handles logging\",VIOLATION\n";
	}elsif ( -f ${logFileLocation} ){
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.2 Logging\",\"If logfile used, it must exist\",\"Log file exists at ${logFileLocation}\",COMPLIANT\n";
	}else{
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.2 Logging\",\"If logfile used, it must exist\",\"Log file does not exist at ${logFileLocation}\",VIOLATION\n";
	}

}


sub check_osr_permissions(){
	
	my $fileSnapshot = `ls -ld ${SUDOERS}`;
	my @fileAttributes = split(/\s+/,$fileSnapshot);
	my $permissions = $fileAttributes[0];
	my $owner = $fileAttributes[2];
	my $group = $fileAttributes[3];

	if ( $permissions =~ m/........w./ ) {
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.8 protecting Resources - OSRs\",\"Sudo OSR must not be world writable\",\"File ${SUDOERS} has permissions ${permissions} \",VIOLATION\n";
	}else{
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.8 protecting Resources - OSRs\",\"Sudo OSR must not be world writable\",\"File ${SUDOERS} has permissions ${permissions} \",COMPLIANT\n";
	}
	
	
	#CHECK THE OWNER
	my $found=0;
	foreach (@OSR_OWNERS){
		if ( $owner eq $_ ){
			$found=1;
			last;
		}
	}
	
	if ( $found ){
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.8 protecting Resources - OSRs\",\"SUDO OSR files must be owned by OSR UID\",\"File ${SUDOERS} has owner ${owner} \",COMPLIANT\n";
	}else{
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.8 protecting Resources - OSRs\",\"SUDO OSR files must be owned by OSR UID\",\"File ${SUDOERS} has owner ${owner} \",VIOLATION\n";
	}
	
	#CHECK THE OWNER
	$found=0;
	foreach (@OSR_GROUPS){
		if ( $group eq $_ ){
			$found=1;
			last;
		}
	}
	
	if ( $found ){
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.8 protecting Resources - OSRs\",\"SUDO OSR files must be owned by OSR GROUP\",\"File ${SUDOERS} has group ${group} \",COMPLIANT\n";
	}else{
		print OUTPUT_FILE "\"${HOSTNAME}\",\"1.8 protecting Resources - OSRs\",\"SUDO OSR files must be owned by OSR GROUP\",\"File ${SUDOERS} has group ${group} \",VIOLATION\n";
	}

}


sub cache_sudoer_aliases(){
	
	#Build up a list of aliases
	my $lineNum = 0;
	my $lineContinuation=0;
	my $fullLine="";
	foreach my $line ( @SUDOERS_FILE_LINES ){
		++$lineNum;
		my $stripedLine = clear_empty_spaces($line);
		
		#Skip comments
		if ( $stripedLine =~ m/\s*#.*/ ){
			next;	
		}
		

		#Check if the line ends in a forward-slash (Line continuation character )
		if ( $stripedLine =~ m/\\$/ ){
			$stripedLine =~ s/\\$//;
			$lineContinuation=1;
			$fullLine=$fullLine.$stripedLine;
			next;
		}else{
			#Check the entry
			if ( $lineContinuation == 1 ){
				$fullLine=$fullLine.$stripedLine;
				$lineContinuation=0;
			}else{
				$fullLine=$stripedLine;
			}
			
			if ( $fullLine =~ m/.*Defaults.*/i ){
				#Strip key word
				$fullLine =~ s/Defaults//i;
				
				#Remove blanks
				$fullLine=clear_empty_spaces($fullLine);
				
				#Get handle
				push(@defaultSettings,$fullLine);

			}

			$lineContinuation=0;
			$fullLine="";
		}
		
		
	}
	
}

sub main(){
	print OUTPUT_FILE "HOSTNAME,SECTION,DESCRIPTION,CURRENT VALUE,SECURITY POSTURE\n";
	#START
	#Cache sudoers file
	cache_sudoer_file();
	cache_sudoer_aliases();
	check_logfile_settings();
	check_osr_permissions();
	
}


main();
close ( OUTPUT_FILE );
