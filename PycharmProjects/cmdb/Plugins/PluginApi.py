#!/usr/bin/env python
#coding:utf-8

import os
import json
from SystemPlugin import SystemPlugin
from cpuPlugin import cpuPlugin
from MemPlugin import MemPlugin
from NicPlugin import NicPlugin
from DiskPlugin import DiskPlugin
from backend.base_response import BaseResponse

def get_server_info():
    response = BaseResponse()
    try:
        systemObj = SystemPlugin()
        system_dict = systemObj.execute()
        cpuObj = cpuPlugin()
        cpu_dict = cpuObj.execute()
        nicObj = NicPlugin()
        nic_dict = nicObj.execute()
        memObj = MemPlugin()
        mem_dict = memObj.execute()
        diskObj = DiskPlugin()
        disk_dict = diskObj.execute()

        server_info_dict= dict(system_dict,**cpu_dict)
        server_info_dict= dict(server_info_dict,**mem_dict)
        server_info_dict= dict(server_info_dict,**nic_dict)
        server_info_dict= dict(server_info_dict,**disk_dict)

        response.data = server_info_dict
        response.status = True
    except Exception,e:
        response.message = e.message
    return response

#print json.dumps(server_info_dict,indent=4)
#print MemPlugin.instance()



