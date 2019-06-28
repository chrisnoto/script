#!/usr/bin/env python
#coding:utf-8

import BasePlugin
import dmidecode
class MemPlugin(BasePlugin.BasePlugin):

    def parse(self,content):
        pass

    def linux(self):
        mem_dict={}
        i=1
        for v in dmidecode.memory().values():
            if type(v) == dict and v['dmi_type'] == 17:
                slot = v['data']['Bank Locator']
                manufacturer = v['data']['Manufacturer']
                sn = v['data']['Serial Number']
                size = v['data']['Size']
                mtype = v['data']['Type']
                num = str(i)
                temp = {num:{'manufacture':manufacturer,'sn':sn,'slot':slot,'size':size,'mtype':mtype}}
                mem_dict = dict(mem_dict,**temp)
                i +=1
        mem_dict=dict(memory=mem_dict)
        return mem_dict

    def windows(self):
        pass

#print MemPlugin.instance()
if __name__ == '__main__':
    memObj=MemPlugin()
    print memObj.execute()