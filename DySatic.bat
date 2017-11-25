

echo off
cls
REM Author: SweetRush Coder
REM Dption: This script Automates the DHCP to Static Addressing
REM --------------------------------------------------------------- 
REM RUN THIS APPLICATION SCRIPT IN ADMINISTRATION RIGHTS
REM ---------------------------------------------------------------

set strStaticSubNet=255.255.255.0
set strStaticGateway=10.201.2.1
set strStaticDNS=202.27.183.3
set strBDoorIP=10.201.2.20
set strInterface="Local Area Connection 2"   
REM Change this to the interface you want to Change Ethernet Name
set strStaticSRC=static 

echo ............................................
echo    DySatic : Version 1.0 
echo    Author: SweetRush Coder 
echo    website: www.suetenaloia.com
echo ............................................
echo ....................Options.................
echo     [1] Set IP configuration as DHCP
echo     [2] Set IP configuration as Static 
echo ............................................

set /p Choice= Select Option to Config IP : 
if %Choice%==1 goto opt1
if %Choice%==2 goto opt2
if NOT %Choice%==1 goto opt3
if NOT %Choice%==2 goto opt3
:opt1
echo Please wait while DNS and DHCP configuration are Processing ........
netsh interface ipv4 set address name=%strInterface% source=dhcp                                          
netsh interface ipv4 set dnsservers  name=%strInterface% source=dhcp
timeout /T 4
echo DNS and DHCP Configuration has been Applied.
echo Note: When Using this setting the Setting has been applied but there is a windows problem in changing 
echo       This sitting in the network interface of Choice but connecting it to a DHCP network will work still.
echo       this is the only thing to keep note of.
echo You are about to exit the application.
pause
goto logout                                                                                                               
:opt2
echo Please wait while Static IP-MASK-GATEWAY-DNS are Processing .........
netsh int ipv4 set address name=%strInterface% source=%strStaticSRC% %strBDoorIP% mask=%strStaticSubNet% gateway=%strStaticGateway%
netsh int ipv4 set dns name=%strInterface% source=%strStaticSRC% address=%strStaticDNS% register=primary validate=no 
timeout /T 4
echo You are about to Exit Application.
pause
goto logout

:opt3
echo Option Error no Such Option selected 
echo You are exting the application
goto logout

:logout
echo --------------------------------------
echo   you are exiting the application 
echo --------------------------------------
pause