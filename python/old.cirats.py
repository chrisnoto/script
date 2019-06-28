#!/usr/bin/python2.6
#coding:utf-8
import smtplib
from bs4 import BeautifulSoup
from email.Header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.image import MIMEImage
import requests

strings=[]
s= requests.Session()
url1='https://sydsarmciratihs.sarm.w3cloud.xxx.com/services/security/cirats/index.jsp'
#url2='https://sydsarmciratihs.sarm.w3cloud.xxx.com/services/security/cirats/index.jsp?id=101142393&Topic=300&targetFile=4&recStatusVal=1&Mode=Child-patch-advisory-details&FROM_ACTIVITY=NAVIGATION'

headers ={'User-Agent':'Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0'}
values={'loginName':'chensen@cn.xxx.com',
	'AUTO_REFRESH':"format-only-3",
	'POPUP_CLOSED':"",
	'Mode':"login",
	'Topic':"100",
	'EFLUX_MODE':"login",
	'EFLUX_STATE':"0",
	'eflux-crumb-count':"0",
	'eflux-show-navigation':"false",
	'windowstatus':"0",
	'Command':"",
	'PAGE_REFRESH':"false",
	'password':' '
	}
values2={'POPUP_CLOSED':'',
	'EFLUX_MODE':'PAAdvanced-search',
	'EFLUX_STATE':'0',
	'eflux-crumb-count':'1',
	'eflux-show-navigation':'1',
	'AUTO_REFRESH':'format-only',
	'windowstatus':'0',
	'Command':'',
	'RECORD_STATUS_VW.REC_STATUS':'0',
	'recordNum':'',
	'mpaNum':'',
	'mssOarNum':'',
	'severity':'NULL',
	'recordStatus':'NULL',
	'platform':'',
	'recordType':'0',
	'extRecNum':'',
	'extRecSource':'',
	'targetImplementationDate':'0',
	'notificationTargetDate':'0',
	'competency':'NULL',
	'organization':'NULL',
	'seviceAreaLocator':'NULL',
	'dept':'NULL',
	'subteamName':'NULL',
	'geography':'NULL',
	'country':'NULL',
	'industry':'NULL',
	'offeringType':'NULL',
	'acct':'1144',
	'Mode':'PAAdvanced-search',
	'FROM_ACTIVITY':'pagination',
	'fromMode':'Patch-advisories-list',
	'searchFlag':'PA-ADV-SEARCH-SUBMIT',
	'PAGE_REFRESH':'false'
}
s.get(url1)
s.post(url1,data=values,headers=headers)
s.post(url1,data={'Mode':'PAAdvanced-search','Topic':'300','FROM_ACTIVITY':'NAVIGATION','POPUP_CLOSED':'','PAGE_REFRESH':'false'},headers=headers)
res2=s.post(url1,data=values2,headers=headers)
#res3=s.post(url1,data={'recordLocatorFilter_PAGEID':'2','Mode':'Patch-advisories-list','FROM_ACTIVITY':'PAGING','eflux-crumb-count':'2','acct':'162'},headers=headers)
#res3=s.get(url2,headers=headers)
#print res1.content
#print res2.content
#print res3.content

html= res2.content
soup=BeautifulSoup(html)
for tds in soup.select('.odd td'):
        strings.append(tds.string)
row=zip(* [iter(strings)]*7)
html= """
<html>
<body>
<table border="1">
<tr>
  <th>Record number</th>
  <th>Type</th>
  <th>Platform</th>
  <th>Department</th>
  <th>Account</th>
  <th>Status</th>
  <th>Severity</th>
"""
for r in row:
        url='https://sydsarmciratihs.sarm.w3cloud.xxx.com/services/security/cirats/index.jsp?id='+r[0]+'&Topic=300&targetFile=4&recStatusVal=1&Mode=Child-patch-advisory-details&FROM_ACTIVITY=NAVIGATION'
        html=html+ '<tr><td><a href="'+url+'">'+r[0]+'</a></td><td>'+r[1]+'</td><td>'+r[2]+'</td><td>'+r[3]+'</td><td>'+r[4]+'</td><td>'+r[5]+'</td><td>'+r[6]+'</td>'
html=html+"""
</table>
</body>
</html>
"""

def sendMail(sender,receiver,subject,body):
        smtpserver = 'cfxxxl08.au.xxx.com'

        msg = MIMEMultipart('alternative')
        msg['Subject']= Header(subject,'utf-8')

        htm = MIMEText(body,'html','utf-8')
        msg.attach(htm)

        smtp = smtplib.SMTP()
        smtp.connect('cfxxxl08.au.xxx.com')
        smtp.sendmail(sender,receiver,msg.as_string())
        smtp.quit()

sender='linuxup@au1.xxx.com'
receiver = 'chensen@cn.xxx.com'
subject = 'Patch Advisory CIRATS  --DJ Linux'
body = html

sendMail(sender,receiver,subject,body)
