#!/usr/bin/python2.6
import xlsxwriter

workbook= xlsxwriter.Workbook('/home/chensen/report/CPUMonitor_Boxing_Day_2015.xlsx')
worksheet = workbook.add_worksheet()
worksheet2 = workbook.add_worksheet()

worksheet.set_row(0,43)
worksheet.set_column('A:B',12)
worksheet.set_column('C:AD',16)

format_title1= workbook.add_format()
format_title1.set_bg_color('#FF6622')
format_title1.set_border(1)
format_title1.set_bold(1)
format_title1.set_text_wrap(1)
format_title2= workbook.add_format()
format_title2.set_bg_color('#FF6662')
format_title2.set_border(1)
format_title2.set_bold(1)
format_title2.set_text_wrap(1)
format_mytime= workbook.add_format()
format_mytime.set_bg_color('#FFFF00')
format_mytime.set_border(1)
format_mytime.set_bold(1)

format_data= workbook.add_format()
format_data.set_num_format('0.00')

title2=['Web Server\nau04qws001djsr2','Database\nServer #1\nau04qdb001djsr2','Database\nServer #2\nau04qdb002djsr2','Sterling OMS\nau04qap001djsr2','Sterling WMS\nau04qap002djsr2','WESB Server\nau04qap004djsr2']

title1=['CPU usage\nBoxing Day\n2015','App Server\nAvge','WCS App\nServer #1\nau04qap005djsr2','WCS App\nServer #2\nau04qap006djsr2','WCS Search\nServer 1\nau04qap007djsr2','WCS Stage\nServer\nau04qap008djsr2','WCS App\nServer #3\nau04qap009djsr2','WCS App\nServer #4\nau04qap013djsr2','WCS App\nServer #5\nau04qap014djsr2','WCS App\nServer #6\nau04qap015djsr2','WCS App\nServer #7\nau04qap016djsr2','WCS App\nServer #8\nau04qap017djsr2','Solr Search\nServer #2\nau04qap018djsr2','WCS App\nServer #9\nau04qap019djsr2','WCS App\nServer #10\nau04qap020djsr2','WCS App\nServer #11\nau04qap021djsr2','WCS App\nServer #12\nau04qap022djsr2','WCS App\nServer #13\nau04qap023djsr2','WCS App\nServer #14\nau04qap024djsr2','WCS App\nServer #15\nau04qap025djsr2','WCS SLOR\nServer #3\nau04qap026djsr2','WCS App\nServer #16\nau04qap027djsr2','WCS App\nServer #17\nau04qap028djsr2','WCS SOLR\nServer #4\nau04qap029djsr2']

mytime=['7:00','7:20','7:40','8:00','8:20','8:40','9:00','9:20','9:40','10:00','10:20','10:40','11:00','11:20','11:40','12:00','12:20','12:40','13:00','13:20','13:40','14:00','14:20','14:40','15:00','15:20','15:40','16:00','16:20','16:40','17:00','17:20','17:40','18:00','18:20','18:40','19:00','19:20','19:40','20:00','20:20','20:40','21:00']

worksheet.write_row('A1',title1,format_title1)
worksheet.write_row('Y1',title2,format_title2)

worksheet.write_column('A2',mytime,format_mytime)
myrow=2
cpurow=[]
with open('/home/chensen/report/history','r') as f:
	for line in f.readlines():
		col1='C'+str(myrow)
		col2='X'+str(myrow)
		cpurow=line.strip('\n').split(":")
		cpurow2=map(float,cpurow)
		worksheet.write_formula('B'+str(myrow),'=AVERAGE('+col1+':'+col2+')',format_data)
		worksheet.write_row('C'+str(myrow),cpurow2,format_data)
		myrow=myrow+1
f.closed
workbook.close()
