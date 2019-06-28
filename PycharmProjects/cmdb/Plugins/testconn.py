#!/usr/bin/env python
# coding:utf-8

import requests
import json

value = {
    "username": "jiang",
    "password": "9d3",
    "email": "ji@sina.com"
}
value = dict(data=value)

s = requests.Session()
url = "http://192.168.122.199:8000/app01/test/"
headers = {"Content-type": "application/json"}
try:

    ret = s.post(url, json=value, headers=headers)
    print ret.content
except Exception, e:
    raise e
