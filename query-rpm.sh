#!/bin/bash
    #
    # RPM research: query the RPM database

    echo 'Enter the name of an RPM or file'
    read RPM
    echo 'select a task from the menu'
    select TASK in 'Check from which RPM this file comes' 'Check if
     this RPM is installed' 'Install this RPM' 'Remove this RPM'
    do
    case $REPLY in
            1)TASK="rpm -qf $RPM";;
            2)TASK="rpm -qa | grep $RPM";; 
            3)TASK="rpm -ivh $RPM";;
            4)TASK="rpm -e $RPM";;
            *) echo error && exit l;;
    esac
            if [ -n "$TASK" ]
            then
                   clear
                   echo "you have selected TASK"
                   eval $TASK
                   break
            else
                   echo "invalid choice"
            fi
    done
