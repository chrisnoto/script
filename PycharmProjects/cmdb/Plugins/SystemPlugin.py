#!/usr/bin/env python
import dmidecode
import socket
import BasePlugin

class SystemPlugin(BasePlugin.BasePlugin):

    def parse(self):
        pass

    def linux(self):
        hardware_dict={}
        hostname = socket.gethostname()
        for v in dmidecode.system().values():
            if type(v) == dict and v['dmi_type'] == 1:
                manufacturer = v['data']['Manufacturer']
                model = v['data']['Product Name']
                sn = v['data']['Serial Number']
        return {'hostname':hostname,'manufactory':manufacturer,'model':model,'sn':sn}

if __name__ == '__main__':
    systemObj=SystemPlugin()
    print systemObj.execute()


