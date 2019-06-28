#!/usr/bin/env python

from threading import Thread
import time

def run(a=None,b=None):
    print a,b
    time.sleep(1)

t=Thread(target = run, args=(3,4))
t.start()
t.join()