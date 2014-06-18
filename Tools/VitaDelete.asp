<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="../Connections/MySQL.asp" -->
<%
' Establishing the connection to the database
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING

' Query information about member
sSQL="SELECT * FROM directory.employees WHERE Username = '" & Session("User") & "'" 
Set MemberName= oConn.Execute(sSQL)
Name = (MemberName.Fields.Item("lname").Value) & Left(MemberName.Fields.Item("fname").Value,1) & ".pdf"

dim fs
Set fs=Server.CreateObject("Scripting.FileSystemObject") 
fs.DeleteFile("D:\inetpub\wwwroot\Vitas\"& Name)

set fs=nothing

Set MemberName = Nothing
Set oConn = Nothing
Response.redirect("FacultyVita.asp")
%>