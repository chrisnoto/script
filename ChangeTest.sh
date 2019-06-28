#!/bin/sh

cd /home/lanid/MyCommands/PackageChecking/RaisedChange/
vi 

YourID=`whoami`
highlist=/tmp/${YourID}_pkglist_high_version
pkgver=/tmp/${YourID}_pkgver
tmplist=/tmp/${YourID}_tmplist

Change=`ls -lt|grep -v total|head -1|awk '{print $NF}'`
echo "Is the change file name correct: $Change ? y/n"
read answer
if [ "$answer" != "y" ]; then
	echo "Please enter the correct change number:"
	read answer2
	Change=$answer2
fi

sudo chgrp wheel $Change
sudo chmod 666 $Change

for srv in `cat $Change |grep ':' |cut -d: -f2|sort|uniq`; do 
	echo -e "\033[43;37;5m ################### $srv ################### \033[43;37;0m"
	cat /dev/null > $highlist
	#Pickup the highest version
	echo "Sort out the packages which need to be uploaded to server, remove lower version if they are exist ......"
	grep $srv $Change|grep -v '/'|cut -d: -f3|sed "s/\t\t*/ /g"|sed 's/^  *//g'|sed 's/  */ /g'|cut -d" " -f1,3 |sort|uniq > /tmp/${YourID}_${srv}.pkglist
	for pkg in `cat /tmp/${YourID}_${srv}.pkglist|cut -d" " -f1|sort|uniq`; do 
		grep "^$pkg " /tmp/${YourID}_${srv}.pkglist|sed 's/\.x86_64//g' |sed 's/\.i386//g' |sed 's/\.i586//g'|sed 's/\.noarch//g'|sed 's/\.i686//g' |sort -g >$pkgver
		Fstring=
		for ((i=1; i<=15; i++)); do
			string=`cat $pkgver|cut -d" " -f2|tr '.' ' '|tr '-' ' ' |tr '_' ' '|cut -d" " -f$i|sort -n|tail -1`
			if [ "${string}X" != "X" ]; then
				Fstring=`echo ${Fstring}.${string}|sed 's/^\.//'`
        	                grep $Fstring $pkgver> $tmplist; mv $tmplist $pkgver
        	        else
                                break
                	fi
                done
		cat $pkgver|sort|uniq >> $highlist
	done
	cat /dev/null > ${highlist}.bk
	cat $highlist |while read line;do
		pkgname=`echo $line|cut -d" " -f1`
		highver=`echo $line|cut -d" " -f2`
		grep "$pkgname " /tmp/${YourID}_${srv}.pkglist | grep $highver  >> ${highlist}.bk
	done
	mv ${highlist}.bk $highlist
	TotallPkgNum=`wc -l $highlist|awk '{print $1}'`
	pkgs=`cat $highlist|tr " " '-'|sed 's/$/.rpm/g'`
	OStype=`grep $srv $Change |cut -d: -f1|sort|uniq`
	#if [ `grep $srv $Change |grep -ic x86_64` -gt 0 ]; then
	#	case $OStype in
	#		RedHat5Server) DownloadPath="/data/mrepo/rhel-server-5-x86_64/updates" ;;
	#		RedHat6Server) DownloadPath="/data/mrepo/rhel-server-6-x86_64/updates" ;;
	#		RedHat4ES) DownloadPath="/data/mrepo/rhel-es-4-x86_64/updates" ;;
         #               RedHat4AS) DownloadPath="/data/mrepo/rhel-as-4-x86_64/updates" ;;
                #        SLES10-SP4_x86_64) DownloadPath="/data/mrepo/sles-10-sp4-x86_64/updates/rpm/x86_64" ;;
                 #       SLES11-SP2_x86_64) DownloadPath="/data/mrepo/sles-11-sp2-x86_64/updates/rpm/x86_64" ;;
#		esac
#	else
#		case $OStype in
 #                       RedHat5Server) DownloadPath="/data/mrepo/rhel-server-5-i386/updates" ;;
#			RedHat6Server) DownloadPath="/data/mrepo/rhel-server-6-i386/updates" ;;
#			RedHat4ES) DownloadPath="/data/mrepo/rhel-es-4-i386/updates" ;;
#			RedHat4AS) DownloadPath="/data/mrepo/rhel-as-4-i386/updates" ;;
#			RedHat3AS) DownloadPath="/data/mrepo/rhel-as-3-i386/updates" ;;
#			RedHat3ES) DownloadPath="/data/mrepo/rhel-es-3-i386/updates" ;;
 #                       SLES10-SP4_x86) DownloadPath="/data/mrepo/sles-10-sp4-i586/updates/rpm/i586" ;;
#		esac
#	fi

	echo "Do you want to copy the $TotallPkgNum packages to server: $srv ? y/n"
	read answ
	if [ "$answ" = "y" ]; then
			
		echo " "
		echo "Now, copy packages to server"
		echo "--------------------------------"
		echo "$pkgs"|xargs
		echo "--------------------------------"
#		cd $DownloadPath
		ssh $srv "mkdir /home/${YourID}/pkg; rm -f /home/${YourID}/pkg/*"
		cat /dev/null > /tmp/${YourID}_${srv}_pkgnotcopy
		
		if [ $OStype == SLES11-SP2_x86_64 -o $OStype == SLES10-SP4_x86_64 -o $OStype == SLES10-SP4_x86  ]; then
			Path1=`echo $OStype|tr 'A-Z' 'a-z' |sed 's/sles1/sles-1/g' |sed 's/_x86$/-i586/g'|sed 's/_x86/-x86/g'`
			DownloadPath="/data/mrepo/$Path1/updates/rpm"
			for pkg in $pkgs;do
				if [ `echo $pkgs|grep -c x86_64` -gt 0 ]; then
					Arch=x86_64
				else
					Arch=i586
				fi
				scp $DownloadPath/$Arch/$pkg @$srv:/home/$YourID/pkg/ 
				if [ $? -gt 0 ]; then
					if [ `echo $pkg |grep -c i586` -gt 0 ]; then
						Arch=i586
					elif [ `echo $pkg |grep -c noarch` -gt 0 ]; then
                                                Arch=noarch
					else
						Arch=src
					fi
					scp $DownloadPath/$Arch/$pkg @$srv:/home/$YourID/pkg/	 
				fi
				if [ $? -gt 0 ]; then
					echo $pkg >> /tmp/${YourID}_${srv}_pkgnotcopy 
				fi
			done
		elif [ $OStype == RedHat6Server -o  $OStype == RedHat5Server ]; then
			OS=`echo $OStype|cut -c7`
			if [ `echo $pkgs |grep -c x86_64` -gt 0 ]; then
				Arch=x86_64
			else
				Arch=i386
			fi
			DownloadPath="/data/mrepo/rhel-server-$OS-$Arch/updates"
			for pkg in $pkgs;do
				scp $DownloadPath/$pkg @$srv:/home/$YourID/pkg/
				if [ $? -gt 0 ]; then
					echo $pkg >> /tmp/$ourID}_${srv}_pkgnotcopy 
				fi
			done	
		
		elif [ $OStype ==  RedHat4ES -o $OStype ==  RedHat4AS -o $OStype == RedHat3AS -o $OStype == RedHat3ES ]; then
			OSnum=`echo $OStype|cut -c7`
			OSArc=`echo $OStype|cut -c8,9|tr 'A-Z' 'a-z'`
			if [ `echo $pkgs |grep -c x86_64` -gt 0 ]; then
                                Arch=x86_64
                        else
                                Arch=i386
                        fi
			DownloadPath="/data/mrepo/rhel-$OSArc-$OSnum-$Arch/updates"
			for pkg in $pkgs;do
                                scp $DownloadPath/$pkg @$srv:/home/$YourID/pkg/
				if [ $? -gt 0 ]; then
                                        echo $pkg >> /tmp/${YourID}_${srv}_pkgnotcopy 
                                fi
			done	
		fi
		#check if there are missed copy packages
		if [ -s /tmp/${YourID}_${srv}_pkgnotcopy ]; then
			echo -e "\033[42;37;5m Totally, there are $TotallPkgNum packages"
			echo -e "\033[44;37;5m`wc -l /tmp/${YourID}_${srv}_pkgnotcopy |awk '{print $1}'` pakckages miss copy!"
			echo "-----------------------------------------------"
			echo "pkgs list were saved in /tmp/${YourID}_${srv}_pkgnotcopy"
			cat /tmp/${YourID}_${srv}_pkgnotcopy
			echo -e "----------------------------------------------- \033[44;37;0m"
		fi
		cd /home/lanid/MyCommands/PackageChecking/RaisedChange/
	fi
	echo "Do you want to run test command? y/n"
	read ans
	if [ "$ans" = "y" ]; then
		ssh $srv "rpm -Uvh --test /home/${YourID}/pkg/*.rpm"
	else
		continue	
	fi
done
