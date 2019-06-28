#!/usr/bin/python2.6
#coding:utf-8
import smtplib
from email.Header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.image import MIMEImage

def sendMail(sender,receiver,subject):
	smtpserver = 'cfxxxl08.au.xxx.com'
	user = 'chensen'
	password = ''

	msg = MIMEMultipart('alternative')
	msg['Subject']= Header(subject,'utf-8')

	html = """\
	<html>
	<head>for test</head>
	<body><p>Hello</p></body>
	</html>
	"""
	htm = MIMEText(html,'html','utf-8')
	msg.attach(htm)

	smtp = smtplib.SMTP()
	smtp.connect('cfxxxl08.au.xxx.com')
#	smtp.login(user,password)
	smtp.sendmail(sender,receiver,msg.as_string())
	smtp.quit()

sender='linuxup@au1.xxx.com'
receiver = 'chensen@cn.xxx.com'
subject = 'email from 08'

sendMail(sender,receiver,subject)
