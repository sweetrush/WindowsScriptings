REM This is a color Ping
REM Script: colorping 
REM Author: Suetena Faatuuala Loia 
REM Website: www.suetenloia.com
REM Version: 0.1.10
REM EMail: suetena{dot}loia{at}gmail{dot}com

REM Define Static Variables
set logfile="_statuslog.csv"
set statusError=0
set statusSuccess=1


REM Setting Prompt Settings
color 1f 
mode con: cols=60 lines=3
title Connection Status  
echo off & cls

REM set /p getADD=Enter Domain Name:
REM nslookup %getADD%

REM Getting Domain IP / Address
echo [-o-]____Monitor Connection Status  
set /p IP=[-o-]____Enter IP/Domain:
title Connection Status: %IP%
set LogDirectory=.\SPlogs\%IP%_logs\
if exist  %LogDirectory% (
	echo LogDirectory has been created 
	) else (
	 mkdir %LogDirectory%
	)
:start
ping -n 1 %IP% | FIND "TTL="
IF ERRORLEVEL 1 (set out=4f 
set /a "ErrorCount=ErrorCount+1"
set /a "failedPcnt=(%ErrorCount%*100)/(%ErrorCount%+%SuccessCount%)"
cls
 echo Status-ConnectionBad-Unstable  _FC %ErrorCount%  _SC %SuccessCount% _FP %failedPcnt% _SP %successPcnt%  
 echo %Date%,%time%,%statusError%,%statusSuccess% >>%LogDirectory%%IP%%logfile%    
 ) else (set out=2f
  set /a "SuccessCount=SuccessCount+1"
  set /a "successPcnt=(%SuccessCount%*100)/(%ErrorCount%+%SuccessCount%)"
	echo Status-ConnectionGood-Stable _FC %ErrorCount% _SC %SuccessCount% _FP %failedPcnt% _SP %successPcnt%  
	echo %Date%,%time%,%statusSuccess%,%statusError% >>%LogDirectory%%IP%%logfile%
	)
color %out%
goto start