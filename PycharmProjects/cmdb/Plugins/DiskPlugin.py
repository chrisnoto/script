#!/usr/bin/env python
#coding:utf-8
import BasePlugin
import dmidecode
import pyudev

class DiskPlugin(BasePlugin.BasePlugin):

    def parse(self,content):
        pass

    def linux(self):
        disk_dict = {}
        i = 1
        context = pyudev.Context()
        for device in context.list_devices(subsystem='block',DEVTYPE='disk'):
            if device.parent != None and 'sr' not in device.parent.driver:
                name = device.device_node
                size = int(device.attributes['size'])/1024/1024
                disktype = device.parent.attributes['vendor']
                model = device.__getitem__('ID_MODEL')
                sn = device.__getitem__('ID_SERIAL_SHORT')
                rotation_rpm = device.__getitem__('ID_ATA_ROTATION_RATE_RPM')
                slot = device.__getitem__('ID_PATH')[-7:]
                num = str(i)
                temp = {num:{'name':name,'size':size,'disktype':disktype,'model':model,'sn':sn,'rotation_rpm':rotation_rpm,'slot':slot}}
                disk_dict=dict(disk_dict,**temp)
                i +=1
        disk_dict = dict(disk=disk_dict)
        return disk_dict



    def windows(self):
        pass

if __name__ == '__main__':
    diskObj = DiskPlugin()
    print diskObj.execute()