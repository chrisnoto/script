set xlapp = CreateObject("Excel.Application")
set fso = CreateObject("scripting.filesystemobject")
xlapp.Visible = False
'set myfolder = fso.GetFolder("c:\inc308521")
'set myfiles = myfolder.Files
'for each f in myfiles
'   set mybook = xlapp.Workbooks.Open(f.Path)
 '  mybook.SaveAs f.Name & ".xml", 47
 '  mybook.Close
'next
set mybook=xlapp.Workbooks.Open("c:\inc308521\SCCM_vmwscmapp01-dev-IP-Plan-Windows.xls")
mybook.SaveAs "d:\1.xml", 46
 mybook.Close