#!/usr/bin/env python

import Queue
import time
import threading

q=Queue.Queue()

class producer(threading.Thread):
	def __init__(self,i):
		threading.Thread.__init__(self,name="producer Thread-%d" %i)
	def run(self):
		global q
		count=9
		while True:
			for i in range(3):
				if q.qsize() >12:
					pass
				else:
					count=count+1
					msg=str(count)
					q.put(msg)
					print self.name+' '+'producer'+msg+' '+'Queue S
