<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="../Connections/MySQL.asp" -->
<%
' Establishing the connection to the database
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING

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
NameExt= objUpload.Form("NameExt")
'response.write(NameExt)
sSQL="SELECT * FROM documentuploads.categories WHERE NameExt='"&NameExt&"'"
Set DocumentInfo= oConn.Execute(sSQL)

' Query information about member
sSQL="SELECT * FROM directory.employees WHERE Username = '" & Session("User") & "'" 
Set MemberName= oConn.Execute(sSQL)
' Query files for this category for this faculty member
sSQL="SELECT * FROM documentuploads.uploadedfiles WHERE AD='"&Session("User")&"' AND Category='"&NameExt&"' ORDER BY CategoryOrder Desc"
Set DocumentList=oConn.Execute(sSQL,NumofRec)
If NumofRec>0 Then
CategoryOrder=CInt(DocumentList.Fields.Item("CategoryOrder"))+1
Else
CategoryOrder=1
End If
response.write("Order="&CategoryOrder)
'set maximum file size allowed to approx. 1 MBytes
'objUpload.MaxFileSize = 1048576
X=CategoryOrder
Y=1
For Each objUploadedFile in objUpload.Files
If LCase(Right(objUpload.GetFileName(objUploadedFile.OriginalPath),3)) = "pdf" Then
Session("SuccessCode") = 9
Name = MemberName.Fields.Item("lname") & Left(MemberName.Fields.Item("fname"),1) & "-" & DocumentInfo.Fields.Item("NameExt") & "_"&Year(Date())&"_"&X&".pdf"
FileDesc= array(Replace(objUpload.Form("FileDesc1"),"'","''"),Replace(objUpload.Form("FileDesc2"),"'","''"),Replace(objUpload.Form("FileDesc3"),"'","''"),Replace(objUpload.Form("FileDesc4"),"'","''"))

objUploadedFile.SaveAs "D:\inetpub\intranet\documents\" & Name
'response.write(Name)
sSQL="INSERT INTO documentuploads.uploadedfiles (UploadedBy,FileName,AD,Category,DateUploaded,Year,CategoryOrder,Description) VALUES ('"&objUpload.Form("UploaderName")&"','"&Name&"','"&Session("User")&"','"&DocumentInfo.Fields.Item("NameExt")&"','"&EntryDateTime&"','"&Year(Date())&"','"&X&"','"&FileDesc(Y-1)&"')"
Set Updatedatabase= oConn.Execute(sSQL)
X=X+1
Y=Y+1
Else
Session("SuccessCode") = 1
Response.redirect(request.servervariables("http_referer"))
End If
Next

'now trap for success/failure of operation, and also use the control's Form collection
'	to retrieve the name entered by the user so we can send his/her name back to main.asp
dim temp
if err.number <> 0 then
  Session("SuccessCode") = 2
  Session("ErrorMessage")=err.description
end if	
Response.redirect(request.servervariables("http_referer"))

'release resources

'save changes and close recordset
set objUpload = nothing
Set UpdateDatabase = Nothing
Set MemberName = Nothing
Set oConn = Nothing
%>