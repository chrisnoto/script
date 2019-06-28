#!/usr/bin/env python
# coding:utf-8

import BasePlugin
import ethtool


class NicPlugin(BasePlugin.BasePlugin):

    def parse(self, content):
        pass

    def linux(self):
        nic_dict = {}
        i = 1
        # Get info about all devices
        devices = ethtool.get_interfaces_info(ethtool.get_devices())
        # Retrieve and print info
        for dev in devices:
            name = dev.device
            mac = dev.mac_address
            ip = dev.ipv4_address
            netmask = dev.ipv4_netmask
            num =str(i)
            if name != 'lo' and ip is not None:
                temp={num:{'name':name,'mac':mac,'ip':ip,'netmask':netmask}}
                nic_dict = dict(nic_dict,**temp)
                i +=1
        nic_dict = dict(nic=nic_dict)
        return nic_dict

    def windows(self):
        pass

if __name__ == '__main__':
    nicObj = NicPlugin()
    print nicObj.execute()
