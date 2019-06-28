On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
Set f1 = fso.CreateTextFile("666.txt")
strComputer = "."
f1.write (strComputer)
If Err.Description = "" Then
'收集计算机用户信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem", , 48)
J = 0
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Name)) Else f1.write ("," & Trim(objItem.Name)) '收集本地计算机名称，若收集计算机登录帐户的话则使用objItem.UserName
J = J + 1
Next
'收集CPU信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_Processor", , 48)
J = 1
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Name)) Else f1.write ("," & Trim(objItem.Name))
J = J + 1
Next
'收集内存信息
'收集内存总容量
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem", , 48)
J = 2
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.TotalPhysicalMemory)) Else f1.write ("," & Trim(objItem.TotalPhysicalMemory))
J = J + 1
Next
'收集内存外频和数量信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_PhysicalMemory", , 48)
J = 3
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Description) & (objItem.DeviceLocator) & (objItem.Speed)) Else f1.write ("," & Trim(objItem.Description) & (objItem.DeviceLocator) & "," & Trim(objItem.Speed))
J = J + 1
Next
'收集显卡信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_VideoController", , 48)
J = 4
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Caption) & (objItem.VideoModeDescription)) Else f1.write ("," & Trim(objItem.Caption) & (objItem.VideoModeDescription))
J = J + 1
Next
'收集硬盘基本信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_DiskDrive", , 48)
J = 5
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Caption) & (objItem.Size)) Else f1.write ("," & Trim(objItem.Caption) & "," & (objItem.Size))
J = J + 1
Next
'收集声卡信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_SoundDevice", , 48)
J = 6
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.ProductName)) Else f1.write ("," & Trim(objItem.ProductName))
J = J + 1
Next
'收集网卡信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapter", , 48)
J = 7
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Description) & (objItem.MACAddress)) Else f1.write ("," & Trim(objItem.ProductName) & "," & (objItem.MACAddress))
J = J + 1
Next
'收集软驱信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_FloppyDrive", , 48)
J = 8
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Caption)) Else f1.write ("," & Trim(objItem.Caption))
J = J + 1
Next
'收集CDROM信息
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_CDROMDrive", , 48)
J = 9
For Each objItem In colItems
If J = 0 Then f1.write (Trim(objItem.Name)) Else f1.write ("," & Trim(objItem.Name))
J = J + 1
Next
End If
f1.WriteLine ("")
f1.Close 