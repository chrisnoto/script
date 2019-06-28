#!/usr/bin/env python

import time
from multiprocessing import Pool

def run(fn):
    time.sleep(1)
    print fn

if __name__ == "__main__":
    testFL=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    pool = Pool(10)
    pool.map(run,testFL)
    pool.close()
    pool.join()