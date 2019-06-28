#!/usr/bin/env python
#coding:utf-8

from threading import Thread
from Queue import Queue
import paramiko,os,sys
from scp import SCPClient

class Base(object):

    def __init__(self):
        self.fork = 30
        self.srvlist = []
        self.srvdict = {}
        self.__keyfile = os.path.expanduser('~/.ssh/id_rsa')
        self.__user_config_file = os.path.expanduser('~/.ssh/config')
        self.key = None

    def init_srvdict(self):
        with open(self.srvfile) as f:
            for line in f.readlines():
                self.srvlist.append(line.strip())
            self.srvdict = dict.fromkeys(tuple(self.srvlist))

    def get_key(self):
        if os.path.exists(self.__keyfile):
            self.key = paramiko.RSAKey.from_private_key_file(self.__keyfile,password='4DT91@775')
        else:
            self.key = None

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
        pass

    def run(self):
        paramiko.util.log_to_file('ssh.log')
        self.get_key()
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

class Myssh(Base):

    def __init__(self,srvfile,cmd,user='chensen'):
        super(Myssh,self).__init__()
        self.cmd = cmd
        self.user = user
        self.srvfile = srvfile

    def command(self,i,q):
        while True:
            srv = q.get()
            ssh=paramiko.SSHClient()
            ssh.load_system_host_keys()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(hostname=self.srvdict[srv]['hostname'],username=self.user,pkey=self.key,sock=self.srvdict[srv]['proxy'])
            stdin,stdout,stderr = ssh.exec_command(self.cmd)
            print srv + ":\n" + stdout.read()
            ssh.close()
            q.task_done()

class Myscp(Base):

    def __init__(self,srvfile,method,file,path,recursive=False,user='chensen'):
        super(Myscp,self).__init__()
        self.user = user
        self.srvfile = srvfile
        self.method = method
        self.file = file
        self.path = path
        self.func = None
        self.recursive = recursive

    def command(self,i,q):
        while True:
            srv = q.get()
            ssh=paramiko.SSHClient()
            ssh.load_system_host_keys()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(hostname=self.srvdict[srv]['hostname'],username=self.user,pkey=self.key,sock=self.srvdict[srv]['proxy'])
            myscp = SCPClient(ssh.get_transport())
            if self.method == 'get':
                dest = 'local'
                func = getattr(myscp,'get')
                a_path=self.path +srv
                if not os.path.exists(a_path):
                    os.mkdir(a_path)
            elif self.method == 'put':
                dest = srv
                func = getattr(myscp,'put')
                a_path=self.path
            else:
                pass
            func(self.file,a_path,recursive=self.recursive)
            myscp.close()
            ssh.close()
            print self.file + " was transferred to " + dest + " " + a_path
            q.task_done()

if __name__ == '__main__':
    '''------------parallel ssh------------'''
    sshObj = Myssh('/home/sam/PycharmProjects/first_project/my_threading/djs_uat','df -h /home')
    sshObj.run()
    '''------------get 1 file from server '''
    #scpObj = Myscp('/home/sam/PycharmProjects/first_project/my_threading/djs_uat','get','parsedb.py','/home/sam/')
    '''------------get 1 directory from server '''
    #scpObj = Myscp('/home/sam/PycharmProjects/first_project/my_threading/djs_uat','get','1','/home/sam/',True)
    '''------------put 1 file to server '''
    #scpObj = Myscp('/home/sam/PycharmProjects/first_project/my_threading/djs_uat','put','djs_uat','/home/chensen/')
    '''------------put 1 directory to server '''
    #scpObj = Myscp('/home/sam/PycharmProjects/first_project/my_threading/djs_uat','put','1','/home/chensen/',True)
    #scpObj.run()
