<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="../Connections/MySQL.asp" -->
<%
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

dim objUpload		'instance of Upload control
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

EntryDateTime = Year(Date())&"-"&Month(Date())&"-"&Day(Date())&" "&DatePart("h",Now())&":"&DatePart("n",Now())&":"&DatePart("s",Now())

'set maximum file size allowed to approx. 1 MBytes
'objUpload.MaxFileSize = 1048576
For Each objUploadedFile in objUpload.Files
If LCase(Right(objUpload.GetFileName(objUploadedFile.OriginalPath),3)) = "pdf" Then
Session("SuccessCode") = 9
Name = objUpload.Form("FileName")&".pdf"
NameExt = objUpload.Form("NameExt")
objUploadedFile.SaveAs "D:\inetpub\intranet\documents\" & Name
'response.write(Name)
' Establishing the connection to the database
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING
sSQL="UPDATE documentuploads.uploadedfiles SET DateLastUpdated='"&EntryDateTime&"' WHERE filename='"&Name&"'"
Set Updatedatabase= oConn.Execute(sSQL)
Else
Session("SuccessCode") = 1
Response.redirect("FileUploadForm.asp?NameExt="&NameExt)
End If
Next

'now trap for success/failure of operation, and also use the control's Form collection
'	to retrieve the name entered by the user so we can send his/her name back to main.asp
dim temp
if err.number <> 0 then
  Session("SuccessCode") = 2
  Session("ErrorMessage")=err.description
end if	
Response.redirect("FileUploadForm.asp?NameExt="&NameExt)

'release resources

'save changes and close recordset
set objUpload = nothing
Set UpdateDatabase = Nothing
Set MemberName = Nothing
Set oConn = Nothing
%>