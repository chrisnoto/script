:: SCRIPT: serv_valid_win.cmd
:: AUTHOR: Burt Lu (FB SDA)
:: DATE: 11/09/2011
:: REV: 1.0
:: PLATFORM: Windows
:: PURPOSE: This script is to gather server information on the servers built. This information should be used for validating the server builds.
::
::
:: USAGE: serv_valid_win.cmd
:: NOTE: this script should be copied to each new windows server built and to be executed in the above mentioned way. 
::
::
::
::
::
@echo off
echo creating output......
echo = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = >%computername%.txt
echo Server Name : %computername% >>%computername%.txt
echo = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = >>%computername%.txt
echo ---------------------------------------------------------------------- >>%computername%.txt
echo CPU,Memory and OS info >>%computername%.txt
echo ---------------------------------------------------------------------- >>%computername%.txt
:: Memory
for /F "tokens=2 delims==" %%a in ('wmic os get totalvisiblememorysize /value') do set /a memory=%%a/1024
echo Physical Memory: %memory% MB >>%computername%.txt

:: CPU
set /a cpu=0
for /F "tokens=2 delims==" %%a in ('wmic cpu get DeviceID /value') do set /a cpu=cpu+1 
echo CPU Info: %cpu% CPU >>%computername%.txt

:: OS
for /F "tokens=2 delims==" %%a in ('wmic os get caption /value') do set os1=%%a
for /F "tokens=2 delims==" %%a in ('wmic os get CSDVersion /value') do set os2=%%a
echo OS Version: %os1% %os2% >>%computername%.txt


echo ---------------------------------------------------------------------- >>%computername%.txt
:: Disk
echo Disk info >>%computername%.txt
echo ---------------------------------------------------------------------- >>%computername%.txt
wmic logicaldisk get name,description,size,volumename | more >output.tmp
type output.tmp >>%computername%.txt

echo ---------------------------------------------------------------------- >>%computername%.txt
::Network info
echo Network info >>%computername%.txt
echo ---------------------------------------------------------------------- >>%computername%.txt
ipconfig /all >>%computername%.txt

echo ---------------------------------------------------------------------- >>%computername%.txt
::User info
echo User info >>%computername%.txt
echo ---------------------------------------------------------------------- >>%computername%.txt
wmic useraccount get caption,localaccount,Disabled | more >output.tmp
type output.tmp >>%computername%.txt

echo = = = = = = = = = = = = = = = = = = = = = = = = End of output for %computername% >>%computername%.txt

del /q output.tmp
echo Completed.Please find the output file %computername%.txt in the current folder.
pause