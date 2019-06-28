@echo off
for /f "tokens=15 delims= " %%i in ('ipconfig /all^|find /i "address"') do echo/%%i > 1.txt
for /f "tokens=15 delims= " %%i in ('ipconfig /all^|find /i "Subnet"') do echo/%%i  >> 1.txt
for /f "tokens=15 delims= " %%i in ('ipconfig /all^|find /i "DNS"') do echo/%%i     >> 1.txt
for /f "tokens=13 delims= " %%i in ('ipconfig /all^|find /i "Gateway"') do echo/%%i >> 1.txt