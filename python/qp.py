#!/usr/bin/python
import rpm
import sys

ts = rpm.TransactionSet()
mi = ts.dbMatch()
mi.pattern('name',rpm.RPMMIRE_GLOB,sys.argv[1])
for header in mi:
	package=header.sprintf("%{NAME}-%{VERSION}-%{RELEASE}-%{ARCH}")
	insdate=header.sprintf("%{INSTALLTIME:date}")
	print "%-80s %s" %(package,insdate)
#	print "Requires:"
#	ds=header['requires']
#	for d in ds:
#		print "  "+d
