#!/usr/bin/env python
#coding:utf-8

import BasePlugin
import dmidecode

class cpuPlugin(BasePlugin.BasePlugin):

    def parse(self):
        pass

    def linux(self):
        cpu_dict = {}
        i = 1
        for v in dmidecode.processor().values():
            if type(v) == dict and v['dmi_type'] == 4:
                slot = v['data']['Socket Designation']
                model = v['data']['Version']
                num = str(i)
                temp = {num:{'slot':slot,'model':model}}
                cpu_dict = dict(cpu_dict,**temp)
                i +=1
        cpu_dict = dict(cpu = cpu_dict)
        return cpu_dict

    def windows(self):
        pass

if __name__ == '__main__':
    cpuObj = cpuPlugin()
    print cpuObj.execute()

