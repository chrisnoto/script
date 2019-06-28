#!/usr/bin/env python

from threading import Thread
import time

class MyThread(Thread):
    def __init__(self,a,b):
        super(MyThread,self).__init__()
        self.a = a
        self.b = b
    def run(self):
        print self.a,self.b
        time.sleep(1)

t=MyThread(3,4)
t.start()
t.join()
