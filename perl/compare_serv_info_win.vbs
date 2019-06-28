'-------------------------------------------------------------------------------------------------------------------------------------
' Scirpt: compare_ser_info.vbs
' Author: Burt Lu
' Date:  2/6/2012
' Updated:  2/23/2012
' PLATFORM: Windows
' PURPOSE: It can compare the server hardware configuration in "output.xml" and current server.
' USAGE example: 
' 1. Put the script and "output.xml" into a same folder.
' 2. Double click the script file compare_ser_info.vbs to run
' 3. The hostname.txt will be generated in current folder
'--------------------------------------------------------------------------------------------------------------------------------------

'On Error Resume Next
Dim fs,file,WshNetwork,oXML,computername,oXMLRoot,oXMLItems0,oXMLItem0,oXMLItems1,oXMLItem1,oXMLItems2,oXMLItem2,oXMLItems3,oXMLItem3,oXMLItems4,oXMLItem4,memory,interface,VU,storagesize,storagename,storagename0
Set wshShell = CreateObject("Wscript.Shell")
Path = wshShell.CurrentDirectory
mem = 0 
count0 = 0
count2 = 0
num0 =0
num1 = 0
num2 = 0
num3 = 0
num4 = 0
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set oXML = CreateObject("Microsoft.XMLDOM")
Set fs = CreateObject("Scripting.FileSystemObject")
oXML.setProperty "SelectionLanguage","XPath"

'--------------------------------------------
'Get current computer name
'--------------------------------------------
Set colComputers = objWMIService.ExecQuery("Select * from Win32_ComputerSystem") 
For Each objComputer in colComputers  
 computername = objComputer.Name 
Next
 
'--------------------------------------------
'Load output.xml file
'--------------------------------------------
oXML.load path&"\output.xml"
If oXML.parseError.errorCode <> 0 Then
 MsgBox "output.xml format error£º" & Chr(13) &  oXML.parseError.reason
End If
Set oXMLRoot = oXML.documentElement

'--------------------------------------------
'Create result file
'--------------------------------------------
set result=fs.createTextFile(path&"\"&computername&".txt",True)

'--------------------------------------------
'Compare interface info
'--------------------------------------------
set oXMLItems0 = oXMLRoot.selectNodes("/Configuration/Interface/*")
Set colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled= True",,48)	
For each oXMLItem0 in oXMLItems0
if InStr(1,oXMLItem0.nodename,computername,1) then
num0 = num0+1
interface = oXMLItem0.selectSingleNode("IPAddress").text
For Each objItem in colItems
   If Not IsNull(objItem.IPAddress) Then
	 If replace(interface,"""","") = objItem.IPAddress(0) Then
	  count0= count0+1
	 End if
   End if
  Next
End if
Next
result.WriteLine("-----------------------------------------------------------------------------------------------------")
   if num0 = 0 then
   result.WriteLine("!!!IP info fail: There is no Network info of this server in the output.xml file!")
   else
      if count0 = num0 then
      result.WriteLine("IP info: IP info pass.")
      Else
      result.WriteLine("!!!IP info fail: There is " & num0 & " IP address requested," & count0 & " of them pass.")
      End if
    End if
result.WriteLine("-----------------------------------------------------------------------------------------------------")

'--------------------------------------------
'Compare Memroy info
'--------------------------------------------
set oXMLItems1 = oXMLRoot.selectNodes("/Configuration/Memory/*")
For each oXMLItem1 in oXMLItems1
if InStr(1,oXMLItem1.nodename,computername,1) then
num1 = num1+1
memory = oXMLItem1.selectSingleNode("Memory").text
End if
Next
   if num1 = 0 then
   result.WriteLine("!!!Memory info fail: There is no Memory info of this server in the output.xml file!")
   End if

Set colItems = objWMIService.ExecQuery("Select * from Win32_PhysicalMemory",,48)
For Each objItem in colItems
If Not IsNull(objItem.Capacity) Then
	mem = mem + objItem.Capacity
End if
Next
	ttmem= mem/(1024^3)
If cint(replace(memory,"""","")) = ttmem Then
	result.WriteLine("Memory info pass: Real Memory is "& ttmem &"GB,Request is "& replace(memory,"""","") &"GB")
	Else
	result.WriteLine("!Memory info fail: Real Memory is "& ttmem &"GB,Request is "& replace(memory,"""","") &"GB")
End if
result.WriteLine("-----------------------------------------------------------------------------------------------------")

'--------------------------------------------
'Compare Storage info
'--------------------------------------------
set oXMLItems2 = oXMLRoot.selectNodes("/Configuration/Storage/*")
For each oXMLItem2 in oXMLItems2
if InStr(1,oXMLItem2.nodename,computername,1) then
num2 = num2+1
storagesize = oXMLItem2.selectSingleNode("Size").text
storagename = oXMLItem2.selectSingleNode("Drive").text
storagename0 = replace(storagename,"""","")
    Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalDisk where Name='"& storagename0 &"'",,48)
    For Each objItem in colItems
	if cint(objItem.Size/1024^3) = replace(storagesize,"""","") then 
	result.WriteLine("Storage info: Storage info pass")
	Else
	result.WriteLine("!Storage info fail: Requested drive " & storagename0 & " is " & replace(storagesize,"""","") & "GB, Real size is "& cint(objItem.Size/1024^3) &"GB.")
	End if
	Next
End if
Next
   if num2 = 0 then
   result.WriteLine("!!!Storage info fail: There is no Storage info of this server in the output.xml file!")
   End if
result.WriteLine("-----------------------------------------------------------------------------------------------------")

'--------------------------------------------
'Compare CPU info
'--------------------------------------------
set oXMLItems3 = oXMLRoot.selectNodes("/Configuration/VU/*")
For each oXMLItem3 in oXMLItems3
if InStr(1,oXMLItem3.nodename,computername,1) then
num3 = num3+1
VU = oXMLItem3.selectSingleNode("VU").text

Set colItems = objWMIService.ExecQuery("Select * from Win32_Processor where Status='OK'",,48)
    For Each objItem in colItems
	count2= count2+1
	Next
End If
Next
   if num3 = 0 then
   result.WriteLine("!!!CPU info fail: there is no CPU info of this server in the output.xml file!")
   Else
   result.WriteLine("CPU info: The requested VU is " & replace(VU,"""","") &".")
   result.WriteLine("          Real CPU is " & count2 & "CPU.")
   End if
result.WriteLine("-----------------------------------------------------------------------------------------------------")

'--------------------------------------------
'Compare OS info
'--------------------------------------------
set oXMLItems4 = oXMLRoot.selectNodes("/Configuration/OS/*")
For each oXMLItem4 in oXMLItems4
if InStr(1,oXMLItem4.nodename,computername,1) then
num4 = num4+1
OS = oXMLItem4.selectSingleNode("OperatingSystem").text
result.WriteLine("OS info: Requested OS type is:  " & replace(OS,"""",""))
End if
Next
   if num4 = 0 then
   result.WriteLine("!!!OS info fail: there is no OS info of this server in the output.xml file!")
   Else 
   Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)	
      For Each objItem in colItems
	  result.WriteLine("         Real OS type is:  " & objItem.Caption)
      Next
   End if
result.WriteLine("-----------------------------------------------------------------------------------------------------")

result.Close
MsgBox("Script execution is completed!")