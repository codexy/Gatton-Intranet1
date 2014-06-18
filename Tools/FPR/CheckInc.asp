<!--#include file="../../Connections/MySQL.asp" -->
<%
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING
Session.Timeout=1440
' Set session variable for current user
Session("User") = Right(Request.ServerVariables("AUTH_USER"),Len(Request.ServerVariables("AUTH_USER")) - (InStr(Request.ServerVariables("AUTH_USER"),"\")))
sSQL="SELECT * FROM directory.employees WHERE directory.employees.username='"&Session("User")&"'"

Set UserFullName= oConn.Execute(sSQL)
Session("FullName")=UserFullName.Fields.Item("lname")&", "&UserFullName.Fields.Item("fname")
Session("FirstName")=UserFullName.Fields.Item("fname")

sSQL="SELECT * FROM directory.employees LEFT JOIN directory.userlist ON directory.employees.memberid = directory.userlist.employeeid WHERE directory.employees.username = '" & Session("User") & "'"
Set UserPermission= oConn.Execute(sSQL)
Session("FPR")=UserPermission.Fields.Item("FPR")

'Check to make sure session is still active
If Session("User")="" Then ' Session Exists
Response.write("<p>&nbsp;</p><p>Your session has expired. Please restart your session by going to <a href='http://"&request.ServerVariables("HTTP_HOST")&"/Tools/FPR'>http://"&request.ServerVariables("HTTP_HOST")&"/Tools/FPR</a>.</p>")
Else ' Session Exists
If Session("FPR")=0 Then ' Allowed to see FPR tools
Response.write("<p>&nbsp;</p><p>You do not have permissions to view this page.</p>")
Else ' Allowed to see FPR tools
%>
