<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="../Connections/MySQL.asp" -->
<%
' Establishing the connection to the database
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING

sSQL="UPDATE directory.employees SET VitaOther=0, Vita=Null WHERE Username = '" & Session("User") & "'" 
Set UpdateDatabase = oConn.Execute(sSQL)

' Query information about member
sSQL="SELECT * FROM directory.employees WHERE Username = '" & Session("User") & "'" 
Set MemberName= oConn.Execute(sSQL)

Response.Buffer = true
'******************************************************************************
'Copyright Dundas Software Ltd. 2000. All Rights Reserved.
'
'PURPOSE:			This page processes the data POSTED by main.asp.
'					If the upload operation is successful the user will receive
'					  a success message, if the operation fails then a failure
'					  message will be displayed.  These messages will be passed
'					  back to main.asp via a QueryString.	    
'
'POST DESTINATION:  NA           
'
'COMMENTS:			Note that a maximum size of one (1) MBytes per file is
'					  allowed.
'
'					Uploaded files will be saved to memory.			
'
'Dundas Software Contact Information:
'	Email:	sales@dundas.com
'   Phone:	(800) 463-1492
'			(416) 467-5100
'	Fax:	(416) 422-4801
'******************************************************************************

'most methods will throw an exception if the method is unsuccessful so we will
'  enable inline error trapping.
on error resume next

dim objUpload		'instance of Uplaod control
dim strMessage		'stores success/failure message sent back to main.asp

'create an instance of the Upload Control and trap for object creation failure
set objUpload = server.CreateObject("Dundas.Upload.2")
if  err.number <> 0 then
	Response.Redirect "main.asp?Message=" & err.description
end if

'don't use unique file names in the beginning
objUpload.UseUniqueNames = true

'we will temporarily save uploaded files to disk

objUpload.SaveToMemory


'set maximum file size allowed to approx. 1 MBytes
'objUpload.MaxFileSize = 1048576
X=1
For Each objUploadedFile in objUpload.Files
If LCase(Right(objUpload.GetFileName(objUploadedFile.OriginalPath),3)) = "pdf" Then
Session("SuccessCode") = 9
Name = (MemberName.Fields.Item("lname").Value) & Left(MemberName.Fields.Item("fname").Value,1) & ".pdf"
objUploadedFile.SaveAs "D:\inetpub\wwwroot\Vitas\" & Name
Else
Session("SuccessCode") = 1
Response.redirect(request.servervariables("http_referer"))
End If
Next

'now trap for success/failure of operation, and also use the control's Form collection
'	to retrieve the name entered by the user so we can send his/her name back to main.asp
dim temp
'if IsEmpty(objUpload.Form("txtName")) = false then temp = " "
if err.number <> 0 then
  Session("SuccessCode") = 2
  Session("ErrorMessage")=err.description
end if	
Response.redirect(request.servervariables("http_referer"))

'now use a response.redirect to get user back to main.asp
'Response.Redirect "UploadFile.asp?CourseID=" & Request.QueryString("CourseID") & "&Message=" & strMessage

'release resources

'save changes and close recordset
set objUpload = nothing
Set UpdateDatabase = Nothing
Set MemberName = Nothing
Set oConn = Nothing
%>