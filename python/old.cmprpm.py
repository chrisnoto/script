#!/usr/bin/python
import rpm,os,sys

def readRpmHeader(ts, filename):
	""" Read an rpm header. """
	fd = os.open(filename, os.O_RDONLY)
	h = ts.hdrFromFdno(fd)
	os.close(fd)
	return h

ts = rpm.TransactionSet()
header = readRpmHeader(ts,sys.argv[1])
pkg_ds = header.dsOfHeader()
version=''
for inst_h in ts.dbMatch('name', header['name']):
	inst_ds = inst_h.dsOfHeader()
	if inst_ds.EVR()>version:
		version=inst_ds.EVR()
		package=inst_h.sprintf("%{NAME}-%{VERSION}-%{RELEASE}-%{ARCH}")
		

if pkg_ds.EVR() == version:
	print type(pkg_ds.EVR())
	print "Package file is same, no need to upgrade."
	print package +"  ==  "+  pkg_ds.EVR()
elif pkg_ds.EVR() > version:
	print "Package file is newer, OK to upgrade."
	print package +"  <  "+  pkg_ds.EVR()
else:
	print "Package file is older than installed version." 
	print package +"  >  "+  pkg_ds.EVR()
