#!/usr/bin/python
import rpm,os,sys

ts = rpm.TransactionSet()
try:
	f=open('/home/chensen/wanteddb','r')
	for line in f.readlines():
		inst_version=''
		(title,ad,package,version)=line.split(':::')
		mi= ts.dbMatch('name',package)
		for inst_h in mi:
			#inst_ds = inst_h.dsOfHeader()
			if inst_h.sprintf("%{VERSION}-%{RELEASE}")>inst_version:
				inst_version=inst_h.sprintf("%{VERSION}-%{RELEASE}")
		if inst_version!='' and version.strip() > inst_version:
			print package+"    "+inst_version+"  <  "+version
finally:
	if f:
		f.close()
