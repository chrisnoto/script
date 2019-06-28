#!/usr/bin/python2.6

cpurow = []
with open('/home/chensen/report/input','r') as f:
        for line in f.readlines():
                (srv,cpu)=line.split(":")
		cpu=100 - float(cpu.strip('\n'))
		cpu=("%.2f" % cpu)
                cpurow.append(cpu)
f.closed

with open('/home/chensen/report/history','a') as f2:
	f2.write(':'.join(cpurow))
	f2.write('\n')
f2.closed

