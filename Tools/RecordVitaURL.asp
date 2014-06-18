<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include file="../Connections/MySQL.asp" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../GattonStyle.css" rel="stylesheet" type="text/css" />
<title>College Administration Tools</title>
</head>

<body>
<!--#include file="ApplicationHeader.html" -->
<table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="850" height="40" colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" valign="top"><%
' Establishing the connection to the MGT390 database
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING

sSQL= "Select * From directory.Employees Where Username = '"& session("User") & "'"
Set MemberInfo= oConn.Execute(sSQL)
Name = (MemberInfo.Fields.Item("lname").Value) & Left(MemberInfo.Fields.Item("fname").Value,1) & ".pdf"
Set fs=Server.CreateObject("Scripting.FileSystemObject")
If fs.FileExists("d:\inetpub\wwwroot\Vitas\" & NAME) = true Then 
fs.DeleteFile("D:\inetpub\wwwroot\Vitas\"& Name)
set fs=nothing
End If
%><table width="700" border="0" cellpadding="5" cellspacing="0">
  <tr>
    <td align="left">
      <p class="PageHeader">Faculty Web Vita  Tools</p>      
  <%
If request.form("VitaOther") = "" Then ' Missing VitaOther
%>
      You must choose one of the options available. Please go back to the previous page.
      <%
Else ' Missing VitaOther
If request.form("VitaOther")=0 Then
VitaOther = 0
Else
VitaOther = 1
End If
VitaURL = request.form("VitaURL")

If VitaOther = 1 Then ' Change Vita URL
If request.form("VitaURL") = "" OR InStr(VitaURL,"http") = 0 Then ' No Vita URL
%>
      You have not specified a vita location or have specified a location that does not begin with "http". If you wish to have your vita linked from the Gatton website, you must either upload a vita in pdf format or specify a valid  URL for your vita.
      <%
Else ' No Vita URL
' Update Vita URL information
VitaURL="'"&request.form("VitaURL")&"'"
sSQL= "Update directory.Employees Set VitaOther = '" & VitaOther & "', Vita = " & VitaURL & " Where Username = '"& session("User") & "'"
Set UpdateDatabase= oConn.Execute(sSQL)
Set UpdateDatabase = Nothing
Set oConn = Nothing
%>
      Your vita location has been changed.
      <%
End If ' No Vita URL
End If ' Change Vita URL
If VitaOther = 0 Then ' Remove Vita URL
sSQL= "Update directory.Employees Set VitaOther = '0', Vita = Null Where Username = '"& session("User") & "'"
Set UpdateDatabase= oConn.Execute(sSQL)
Set UpdateDatabase = Nothing
%>
      Your vita reference has been removed.
      <%
End If ' Remove Vita
End If ' Missing VitaOther

Set MemberInfo = Nothing
Set oConn = Nothing
%>
      </p></td>
    </tr>
  <tr><td align="center" class="AllCapsTitle10">
    <p>&nbsp;</p>
    <p><a href="FacultyVita.asp">Go back to the vita page</a></p>
  </td>
  </tr>
</table></td>
  </tr>
</table>
</body>
</html>
