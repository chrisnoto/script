#!/usr/bin/env python
#coding=utf-8
import threading
import paramiko

def run(srvname,cmd):
	paramiko.util.log_to_file('/home/sam/mypython/test.log')
	ssh=paramiko.SSHClient()
	ssh.load_system_host_keys()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect(srvname,port=22,username='chensen')
	stdin,stdout,stderr = ssh.exec_command(cmd)
	print stdout.read()
	ssh.close()

threads=[]
list=[]
with open('/home/sam/mypython/srvlist') as f:
	for line in f.readlines():
		list.append(line.strip('\n'))
f.closed
#for u in list:
#	t=threading.Thread(target=func,args=(u,'hostname;uptime'))
#	threads.append(t)

if __name__ == '__main__':
	import sys
	for u in list:
		t=threading.Thread(target=run,args=(u,sys.argv[1]))
		threads.append(t)
	for t in threads:
		t.setDaemon(True)
		t.start()
	t.join(20)	
