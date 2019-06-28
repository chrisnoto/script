On Error Resume Next
Dim fs,file,line
mem = 0
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set fs = CreateObject("Scripting.FileSystemObject")
Set file = fs.OpenTextFile("d:\output.txt", 1)
Do While Not file.AtEndOfStream
line= file.Readline
If InStr(line,"Interface")  Then
	interface= Split(line, " ")

Set colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled= True",,48)	
    For Each objItem in colItems
    If Not IsNull(objItem.IPAddress) Then
	If interface(4) = objItem.IPAddress(0) Then
	Wscript.Echo line & "----------------> IP info pass"
	'Else
	' Wscript.Echo line & "----------------> IP info fail"
	End if
    End if
    Next
	
End If

If InStr(line,"Memory")  Then
	interface= Split(line, " ")

Set colItems = objWMIService.ExecQuery("Select * from Win32_PhysicalMemory",,48)	
    For Each objItem in colItems
    If Not IsNull(objItem.Capacity) Then
	mem = mem + objItem.Capacity
	End if
	Next
	ttmem= mem/(1024^3)
	If CInt(interface(2)) = ttmem Then
	Wscript.Echo line & "----------------> Memory info pass"
	Else
	 Wscript.Echo line & "----------------> Memory info fail"
    End if
	mem = 0
 	
End If

If InStr(line,"OS_type")  Then
	interface= Split(line, " ")
	Wscript.Echo "Requested OS type is:  " & interface(2) &  " " & interface(3) & " " & interface(4)

Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)	
    For Each objItem in colItems
	Wscript.Echo "Real OS type is:  " & objItem.Caption
    Next
	
End If

Loop
file.Close
