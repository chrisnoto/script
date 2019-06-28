#!/usr/bin/env python
#coding:utf-8

from threading import Thread
from Queue import Queue
import paramiko,os,sys

class myssh():

    def __init__(self,user,file,cmd):
        self.fork = 30
        self.user = user
        self.srvlist = []
        self.srvdict = {}
        self.srvfile = file
        self.cmd = cmd
        self.__keyfile = os.path.expanduser('~/.ssh/id_rsa')
        self.__user_config_file = os.path.expanduser('~/.ssh/config')

    def init_srvdict(self):
        with open(self.srvfile) as f:
            for line in f.readlines():
                self.srvlist.append(line.strip())
            self.srvdict = dict.fromkeys(tuple(self.srvlist))




    def get_key(self):
        if os.path.exists(self.__keyfile):
            key = paramiko.RSAKey.from_private_key_file(self.__keyfile,password='4DT91@775')
        else:
            key = None
        return key

    def fill_in_srvdict(self):
        ssh_config = paramiko.SSHConfig()
        if os.path.exists(self.__user_config_file):
            with open(self.__user_config_file) as f:
                ssh_config.parse(f)
                for srv in self.srvlist:
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
                    self.srvdict[srv]=dict(dict(hostname=hostname,proxy=proxy))





    def command(self,i,q):
        key = self.get_key()

        while True:
            srv = q.get()
            ssh=paramiko.SSHClient()
            ssh.load_system_host_keys()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(hostname=self.srvdict[srv]['hostname'],username=self.user,pkey=key,sock=self.srvdict[srv]['proxy'])
            stdin,stdout,stderr = ssh.exec_command(self.cmd)
            print srv + ":\t" + stdout.read()
            ssh.close()
            q.task_done()

    def run(self):
        paramiko.util.log_to_file('ssh.log')
        self.init_srvdict()
        self.fill_in_srvdict()
        queue = Queue()
        for i in range(self.fork):
            worker = Thread(target=self.command,args=(i,queue))
            worker.setDaemon(True)
            worker.start()

        for srv in self.srvlist:
            queue.put(srv)
            queue.join()

if __name__ == '__main__':
    sshObj = myssh('chensen','/home/sam/PycharmProjects/first_project/ssh_multi/djs_srvlist','uptime')
    sshObj.run()
