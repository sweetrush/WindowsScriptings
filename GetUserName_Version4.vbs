'Author Script: sweetrush'
'Version: 3.14.4.14'
'Purpose: This script is to track user login and computer address and more'


'## Customizing the look '
CompanyORGroup = "YOUR COMPANY NAME OR GROUP "


Dim objNet
Dim sDate
Dim sTime
Dim sDateString

sDate         = Date()
sTime         = Time()
sDateString 	  = Day(sDate) & "D" & Month(sDate) & "M" & Year(sDate)  

On Error Resume Next 

'In case we fail to create object then display our custom error

Set objNet = CreateObject("WScript.NetWork") 
If  Err.Number <> 0 Then                'If error occured then display notice
	MsgBox "Don't be Shy." & vbCRLF &_
               "Do not press ""No"" If your browser warns you."
	Document.Location = "UserInfo.html"	  
                                        'Place the Name of the document. 
	                                'It will display again
End if
	
Dim strInfo

'Start of IP Code here '
Const HKEY_LOCAL_MACHINE = &H80000002
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" &_
".\root\default:StdRegProv")

Set WSHShell = CreateObject("Wscript.Shell")
strKeyPath = "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\"
oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys

For Each subkey In arrSubKeys
    'WScript.Echo strKeyPath & subkey & "\DhcpIPAddress"
    DHCPAddress = WSHShell.RegRead("HKLM\" & strKeyPath & subkey & "\DhcpIPAddress")
    If DHCPAddress <> "0.0.0.0" And Left(DHCPAddress,3) <> "169" Then
        ActiveDHCPIPAddress = DHCPAddress    
    End If
Next
'WScript.Echo "YourIP  Address is : " & ActiveDHCPIPAddress'       '//This is to popup a dialog that has your IP address'
	
'End of IP Code ends here'

'##############################################################'
'## MESSAGE BOX CODE START HERE '
'## :: The message box code is the code that will prompt the '
'## :: user that they are login to the network '

strInfo = "=====================[  LY & SB  ]==================                "& vbCRLF & vbCRLF & _
		  "Connecting to the "& CompanyORGroup & " Network " & vbCRLF & vbCRLF & _
		  "You are Logged in as " & objNet.UserName & " You are Entering a top Level Network " & vbCRLF & vbCRLF & _
		  " LOGIN USER INFORMATION TRACKING LOGIN " & vbCRLF & _
		  " =================================================== " & vbCRLF & vbCRLF & _
		  "User Name     	is:  " & objNet.UserName & vbCRLF & _
          "Computer Name 	is:  " & objNet.ComputerName & vbCRLF & _
          "Domain Name   	is:  " & objNet.UserDomain & vbCRLF & _
		  "IP address    	is:  " & ActiveDHCPIPAddress & vbCRLF & _
		  "Date		is:  " & sDate & vbCRLF & _
		  "DateString		is:  " & sDateString & vbCRLF & _
		  "Time		is:  " & sTime & vbCRLF & vbCRLF & _
		  " =================================================== " & vbCRLF & vbCRLF & _
		  "YOU HAVE BEEN LOGGED, THANKYOU " & vbCRLF & vbCRLF & _
		  "**This is in reference to "& CompanyORGroup &" Secure and Maintenance Policies to help reduce the Unwanted/Unauthorised  Connections " & vbCRLF & _
		  "**That could render the systems which control the Busniess load of "& CompanyORGroup &" in the case of a Digital Blackout. "& vbCRLF & vbCRLF



'## To disable this message box commment the line blow'
MsgBox strInfo


'############################################################################################################## '
'#### EMAIL INFORMATION CODE STARTS HERE '
'#### :: The information gathered for the tracking login , this information is sent to the email address notes  '
'#### :: in the email variables below.'
'###############################################################################################################'

Dim UserName 
Dim ComputerName 
Dim DomainName 
Dim IPAddressName
Dim EmailServerAddress
Dim dlimit

dlimit 	= ","

UserName      = objNet.UserName
ComputerName  = objNet.ComputerName
DomainName    = objNet.UserDomain
IPAddressName = ActiveDHCPIPAddress 

'## Customizing the look '
CompanyORGroup = "YOUR COMPANY NAME OR GROUP "

'## Email server address '
EmailServerAddress = "email.server.address"
EmailServerPort    = 25

'###########################'
'Send Email information '
'###########################'

 Set objMessage = CreateObject("CDO.Message")

 '## Subject of the Email Tracker' 
 objMessage.Subject = "address for User " & UserName

 '## Just a notable Email of the tracking service User'
 objMessage.Sender = "example@sender.mail.tracker"

 '## Add email address of who will recieve notification of user login'
 objMessage.To = "name@server.mail.server,name@server.mail.server,name@server.mail.server"
 
 '################################################################################################'
 '## Body of the Email Content for the Tracking Information '
 '################################################################################################'

 objMessage.TextBody = " [UserName]		: " & UserName & vbCRLF & _
					   " [ComputerName]	: " & ComputerName & vbCRLF & _
					   " [IP Address]	: " & IPAddressName & vbCRLF & _
					   " [DomainName]	: " & DomainName & vbCRLF & _ 
					   " [Date]		: " & sDate & vbCRLF & _
					   " [DateString]		is:  " & sDateString & vbCRLF & _
					   " [Time]		: " & sTime & vbCRLF & vbCRLF & _
					   " | **Automated information**"& CompanyORGroup &"** |"
 
 '## CONFIGURATION OF EMAIL SERVER SETTINGS TO BE USED '
 objMessage.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing")=2

'SMTP Server
objMessage.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver")= EmailServerAddress

'SMTP Port
objMessage.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport")= EmailServerPort 

objMessage.Configuration.Fields.Update
 
 objMessage.Send

set objMessage=nothing	
Set objNet = Nothing                    'Destroy the Object to free the Memory


'####################################################'
'## Send information to File'
'####################################################'

Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(".\logTr\" & sDateString & "_log_.txt",8,true)
objFileToWrite.WriteLine(UserName & dlimit & ComputerName & dlimit & IPAddressName & dlimit & DomainName & dlimit & sDate & dlimit & sTime)
objFileToWrite.Close

Set objFileToWrite = Nothing

'#####################################################'
'## END OF SCRIPT'
'#####################################################'