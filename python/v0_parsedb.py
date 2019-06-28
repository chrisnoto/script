#!/usr/bin/python
import time,datetime,os,sys,re
import rpm

Policy={
	'L':360,
	'M':90,
	'H':60
}

pattern=re.compile(r'advisory')
adlist=[]
startdate=datetime.datetime.today() - datetime.timedelta(days=360)
startdate=int(time.mktime(startdate.timetuple()))

def create_dict_for_package(ad):
	f.seek(0)
	pattern=re.compile(ad)
       	for line in f.readlines():
		if pattern.search(line):
			if 'advisory' in line:
	                       	(title,ad,dtime,sev,desc,blank)=line.split(':::')
                       		dtime=int(dtime)
               	        	if sev in Policy.keys():
                       	        	delta =  Policy[sev]*3600*24
                               		dtime += delta
                    		dtime=time.strftime("%m/%d/%Y",time.localtime(dtime))
                        	per['des']="%-30s %-8s %-15s %s" % (dtime,sev,ad,desc)
                        	combine[ad]=dict(dict(des=per['des'],package=[],match=False))

                	else:
                        	(title,ad,package,ver)=line.split(':::')
                        	packagename=package+' '+ver.strip()
                        	combine[ad]['package'].append(packagename)

try:
	f=open('/home/chensen/secfixdb.RedHat5Server','r')
        for line in f.readlines():
		if pattern.search(line):
			(title,ad,dtime,sev,desc,blank)=line.split(':::')
			if int(dtime)>startdate and sev != 'N':
				adlist.append(ad)
	combine=dict.fromkeys(tuple(adlist))
	per={}
	for ad in adlist:
        	create_dict_for_package(ad)

finally:
	if f:
		f.close()

ts = rpm.TransactionSet()
for k in combine:
	show=[]
	for p in combine[k]['package']:
		inst_version=''
		package,ver=p.split()
		mi= ts.dbMatch('name',package)
                for inst_h in mi:
                        #inst_ds = inst_h.dsOfHeader()
                        if inst_h.sprintf("%{VERSION}-%{RELEASE}")>inst_version:
                                inst_version=inst_h.sprintf("%{VERSION}-%{RELEASE}")
                if inst_version!='' and ver.strip() > inst_version:
                        #print "%-60s %30s < %30s" %(package,inst_version,ver.strip())
                        show.append("%-60s %30s < %30s" %(package,inst_version,ver.strip()))
			combine[k]['match']=True
	if combine[k]['match']==True and show:
		print combine[k]['des']
		for item in show:
			print '  '+item
