#!/usr/bin/env python
#coding:utf-8

import myssh

sshObj = myssh.myssh('chensen','/home/sam/PycharmProjects/first_project/ssh_multi/djs_srvlist','uptime')
sshObj.run()
