#!/usr/bin/env python

class BaseResponse(object):

    def __init__(self):
        self.__status = False
        self.__data = None
        self.__message = ''

    @property
    def status(self):
        return self.__status

    @status.setter
    def status(self,value):
        self.__status = value

    @property
    def message(self):
        return self.__message

    @message.setter
    def message(self,value):
        self.__message = value

    @property
    def data(self):
        return self.__data

    @data.setter
    def data(self,value):
        self.__data = value

