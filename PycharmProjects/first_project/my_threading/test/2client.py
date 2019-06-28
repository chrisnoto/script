#!/usr/bin/env python
import socket
import time

HOST='192.168.122.200'
PORT=50007

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect((HOST,PORT))

while 1:
	INPUT=raw_input('input: ')
	s.sendall(INPUT)
	data=s.recv(4096)
	print 'Received ',repr(data)
	time.sleep(2)
s.close()
