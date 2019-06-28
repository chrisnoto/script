#!/usr/bin/env python
#_*_ coding:utf-8 _*_

from threading import Thread
from Queue import Queue
import paramiko,os,sys

fork = 30
queue=Queue()
username='chensen'
srvlist = []
paramiko.util.log_to_file('ssh.log')

with open('/home/sam/PycharmProjects/first_project/ssh_multi/djs_srvlist','r') as f:
    for line in f.readlines():
        srvlist.append(line.strip())
srvdict=dict.fromkeys(tuple(srvlist))

key_file=os.path.expanduser('~/.ssh/id_rsa')
if os.path.exists(key_file):
    key=paramiko.RSAKey.from_private_key_file(key_file,password='4DT91@775')
else:
    key=None
ssh_config=paramiko.SSHConfig()
user_config_file=os.path.expanduser('~/.ssh/config')
if os.path.exists(user_config_file):
    with open(user_config_file) as f:
        ssh_config.parse(f)
        for srv in srvlist:
            host=ssh_config.lookup(srv)
            if 'hostname' in host:
                hostname=host['hostname'].replace('\t',' ')
            else:
                hostname=srv
            if 'proxycommand' in host:
                proxycmd=host['proxycommand'].replace('\t',' ')
                proxy=paramiko.ProxyCommand(proxycmd)
            else:
                proxy=None
            srvdict[srv]=dict(dict(hostname=hostname,proxy=proxy))

def command(i,q):
    while True:
        srv = q.get()

        ssh=paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())


        ssh.connect(hostname=srvdict[srv]['hostname'],username=username,pkey=key,sock=srvdict[srv]['proxy'])
        stdin,stdout,stderr = ssh.exec_command(sys.argv[1])
        print srv + ":\t" + stdout.read()
        ssh.close()
        q.task_done()

#ssh=paramiko.SSHClient()
#ssh.load_system_host_keys()
#ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
for i in range(fork):
    worker = Thread(target=command,args=(i,queue))
    worker.setDaemon(True)
    worker.start()

for srv in srvlist:
    queue.put(srv)

queue.join()
#ssh.close()