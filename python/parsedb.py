#!/usr/bin/python
#_*_ coding:utf-8 _*_
import platform,time,datetime,os,sys,re
import rpm

#set days for High,Medium,Low sev for different security policy
Policy={
	'L':360,
	'M':90,
	'H':60
}
# check advisory genearted 1 year ago
backto = 360

#define secfixdb file
dist=platform.dist()[1]
dist=int(float(dist))
secfixdb='secfixdb.RedHat'+str(dist)+'Server'
secfixdbfile=os.path.join(os.path.expanduser('~'),secfixdb)


pattern=re.compile(r'advisory')
adlist=[]
cur_pos=0
startdate=datetime.datetime.today() - datetime.timedelta(days=backto)
startdate=int(time.mktime(startdate.timetuple()))

def create_dict_for_package(ad):
	global cur_pos
	total_find_num=0
	f.seek(cur_pos)
	pattern=re.compile(ad)
	while True:
		line=f.readline()
		if pattern.search(line):
			total_find_num+=1
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
				cur_pos=f.tell()
		else:
			if total_find_num > 1:
				return

try:
	f=open(secfixdbfile,'r')
        for line in f.readlines():
		if pattern.search(line):
			(title,ad,dtime,sev,desc,blank)=line.split(':::')
			if int(dtime)>startdate and sev != 'N':
				adlist.append(ad)
	combine=dict.fromkeys(tuple(adlist))
	per={}
	for ad in adlist:
       		create_dict_for_package(ad)
#except Exception,e:
#	print e
finally:
	if 'f' in locals():
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
                if inst_version!='' and ver.strip() > inst_version and len(ver.strip()) >= len(inst_version):
                        #print "%-60s %30s < %30s" %(package,inst_version,ver.strip())
                        show.append("%-60s %30s < %30s" %(package,inst_version,ver.strip()))
			combine[k]['match']=True
	if combine[k]['match']==True and show:
		print combine[k]['des']
		for item in show:
			print '  '+item
