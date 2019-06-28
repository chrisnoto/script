#!/usr/bin/env python
# coding:utf-8

import requests
import time,json
from Plugins import PluginApi

class Program():

    def __init__(self):
        self.server_response = PluginApi.get_server_info()
    def execute(self):
        if self.server_response.status:
            value = {"data":self.server_response.data}

            self.post_data(value)
        else:
            print 'error'

    def post_data(self,value):
        s = requests.Session()
        url = "http://192.168.122.199:8000/app01/collector/"
        headers = {"Content-type":"application/json"}
        try:

            ret = s.post(url,json=value,headers=headers)
            print ret.content
        except Exception,e:
            raise e


if __name__ == '__main__':
    times = 0
    #while True:
    objProgram = Program()
    objProgram.execute()
        #times += 1
        #time.sleep(86400)
