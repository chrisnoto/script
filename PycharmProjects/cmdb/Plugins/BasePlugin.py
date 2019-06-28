#!/usr/bin/env python
#coding:utf-8
import platform
class BasePlugin(object):

    @classmethod
    def instance(cls):
        if hasattr(cls,'instance'):
            return getattr(cls(),'instance')
        else:
            obj=cls()
            setattr(cls,'instance',obj)
            return obj

    def execute(self):
        result = platform.system()
        if result == 'Linux':
            return self.linux()
        elif result == 'Windows':
            return self.windows()
        else:
            raise Exception('unknown OS')


    def linux(self):
        pass




    def windows(self):
        pass

#print BasePlugin.instance()