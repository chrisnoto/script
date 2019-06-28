#!/bin/bash

## This simple script was put together to keep LDAP functioning.
## I have found that on some occassions that after a period of at
## least a few days or more, that LDAP stops answering calls and
## that the database is not able to be read using tools such as slapcat.

## Stopping LDAP, prefomring a db_recover to check integrity and fix
## any issues, then restarting LDAP and dumping to a text based ldif
## file keeps things humming and provides a source for DB rebuilds
## should that ever be needed.

## Grant Bigham - 7 Oct 2005

LDAP="/etc/init.d/ldap"
DB_LOC="/var/lib/ldap"
LDAP_CONF="/etc/openldap"
LOGGER="/usr/bin/logger"
HOSTN=$( hostname | cut -d'.' -f1 )
LDIFN=$( echo "${HOSTN}_"`date +%y%m%d`".ldif" )

$LOGGER "`basename $0` Has Started"

$LOGGER "`basename $0` Stopping LDAP Daemon"
$LDAP stop

$LOGGER "`basename $0` Running db_recover over LDAP DB at $DB_LOC"
db_recover -h "$DB_LOC"
chown -R ldap.ldap "${DB_LOC}"

$LOGGER "`basename $0` Starting LDAP Daemon"
$LDAP start

$LOGGER "`basename $0` Dumping LDAP DB to $LDIFN"
slapcat -l "${LDAP_CONF}/${LDIFN}"

find ${LDAP_CONF}/${HOSTN}_*.ldif -type f -mtime +7 -exec rm -f {} \; > /dev/null 2>&1

$LOGGER "`basename $0` Has Completed"

exit 00
