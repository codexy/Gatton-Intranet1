<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml">
<!--#include file="../Connections/MySQL.asp" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../GattonStyle.css" rel="stylesheet" type="text/css" />
<title>Dean's Office Administration Tools</title>
</head>

<body>
<!--#include file="ApplicationHeader.html" -->
<p>&nbsp;</p>
<%
Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING
sSQL="SELECT * FROM documentuploads.categories WHERE NameExt='"&request.QueryString("NameExt")&"'"
Set DocumentInfo= oConn.Execute(sSQL, NumofRec)

If NumofRec>0 Then ' File type specified
Session("User") = Right(Request.ServerVariables("AUTH_USER"),Len(Request.ServerVariables("AUTH_USER")) - (InStr(Request.ServerVariables("AUTH_USER"),"\")))

sSQL= "Select * From directory.employees Where Username = '"& session("User") & "'"
Set MemberInfo= oConn.Execute(sSQL)
'Show page if member is a faculty member or Melissa
If (MemberInfo.Fields.Item("Position").Value = "Faculty" OR MemberInfo.Fields.Item("Position").Value = "Lecturer") OR MemberInfo.Fields.Item("memberid").Value = 22 OR MemberInfo.Fields.Item("memberid").Value = 1114 OR MemberInfo.Fields.Item("memberid").Value = 1130 Then
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" class="BodyText">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left"><a href="../Index.asp" class="AllCapsTitle10">Go to Admin Console</a></td>
        </tr>
      </table>
    </td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    </tr>
  
  <tr>
    <td height="20" valign="top" class="PageHeader"><p>Faculty Document  Tool - <%=DocumentInfo.Fields.Item("Type")%></p>
      </td>
    </tr>
  <tr>
    <td height="20" valign="top" class="BodyText"><%
Set fs=Server.CreateObject("Scripting.FileSystemObject")
 If Session("SuccessCode") = 1 Then %>
      <p align="center"><font color="#FF0000">You have attempted to upload a file which is not a pdf file. <br />
        Please upload a pdf file.</font></p>
      <% End If 
If Session("SuccessCode") = 2 Then %>
      <p align="center"><font color="#FF0000">Sorry but the following error occurred: <%=Session("ErrorMessage")%></font></p>
      <% End If 
If Session("SuccessCode") = 9 Then %>
      <p align="center"><font color="#FF0000">The upload operation was successfully performed. <br />
        Your document has been saved on the web server.</font></p>
      <% End If %>
    </td>
  </tr>
  <tr>
    <td height="20" valign="top" class="BodyText"><p>You have uploaded the following documents:</p>
<table width="1000" border="1" cellpadding="2" cellspacing="2">
<tr><td class="TableColumnHeaders">File Name</td>
  <td align="center" class="TableColumnHeaders">Date Uploaded</td>
  <td align="center" class="TableColumnHeaders">Relevant Year</td>
  <td align="center" class="TableColumnHeaders">Description</td>
  <td align="center" class="TableColumnHeaders">Update File</td>
</tr>
  <%
sSQL="SELECT * FROM documentuploads.uploadedfiles WHERE AD='"&Session("User")&"' AND Category='"&request.QueryString("NameExt")&"'"
Set DocumentList=oConn.Execute(sSQL,NumofFiles)
If NumofFiles>0 Then ' List files
Do While Not DocumentList.EOF
If IsNull(DocumentList.Fields.Item("DateLastUpdated"))=False Then
DateUploaded=DocumentList.Fields.Item("DateLastUpdated")
Else
DateUploaded=DocumentList.Fields.Item("DateUploaded")
End If
' See file exists
%>
		<tr><td><a href="http://gatton.inet.uky.edu/documents/<%=DocumentList.Fields.Item("FileName")%>" target="_blank"><%=DocumentList.Fields.Item("FileName")%></a></td>
		  <td align="center"><%=DateUploaded%></td>
		  <td align="center"><%=DocumentList.Fields.Item("Year")%></td>
		  <td><%=DocumentList.Fields.Item("Description")%></td>
		  <td align="center"><a href="FileUpdateUploadForm.asp?FileName=<%=Replace(DocumentList.Fields.Item("FileName"),".pdf","")%>&NameExt=<%=request.QueryString("NameExt")%>">Update</a></td>
		</tr>
<% 
DocumentList.MoveNext
Loop
Else %>
<tr><td colspan="8">You currently do not have any documents uploaded.</td></tr>
<%
End If
%>
</table>
  <p class="AllCapsTitle">&nbsp;</p>
  <p class="SubSectionBlue">To upload your <%=DocumentInfo.Fields.Item("Type")%> for the current year, please use the upload utility below.</p>
  <p class="BodyText">You may upload a maximum of four files at one time. If you need to upload more than 4 files, you may submit this form multiple times. Your files will be numbered in the order you submit them.</p>
  <p class="BodyText">Please use the buttons below to browse to the document you want to upload and then click on submit. The document must be in <strong>pdf format</strong>.</p>
  <form action="ProcessFileUpload.asp" method="post" enctype="multipart/form-data" name="form1">
    <table border="0" align="center" cellpadding="3" cellspacing="3">
      <tr>
        <td class="AllCapsTitle10"><strong>File 1: </strong></td>
        <td class="BodyText"><p>
          <INPUT NAME="File1" TYPE="FILE" id="File1" SIZE="30">
          </p>          </td>
        <td class="AllCapsTitle10"><strong>Short Description<br />
          For File 1
          :</strong></td>
        <td class="BodyText"><label for="FileDesc1"></label>
          <textarea name="FileDesc1" id="FileDesc1" cols="35" rows="3"></textarea></td>
      </tr>
      
      <tr>
        <td class="AllCapsTitle10"><strong>File 2: </strong></td>
        <td class="BodyText"><p>
          <input name="File2" type="file" id="File2" size="30" />
          </p></td>
        <td class="AllCapsTitle10"><p><strong>Short Description<br />
          For File 2:
        </strong></p></td>
        <td class="BodyText"><textarea name="FileDesc2" id="FileDesc2" cols="35" rows="3"></textarea></td>
      </tr>
      <tr>
        <td class="AllCapsTitle10"><strong>File 3: </strong></td>
        <td class="BodyText"><p>
          <input name="File3" type="file" id="File3" size="30" />
          </p></td>
        <td class="AllCapsTitle10"><strong>Short Description<br />
          For File 3:
        </strong></td>
        <td class="BodyText"><textarea name="FileDesc3" id="FileDesc3" cols="35" rows="3"></textarea></td>
      </tr>
      <tr>
        <td class="AllCapsTitle10"><strong>File 4: </strong></td>
        <td class="BodyText"><p>
          <input name="File4" type="file" id="File4" size="30" />
        </p></td>
        <td class="AllCapsTitle10"><strong>Short Description<br />
          For File 4:
        </strong></td>
        <td class="BodyText"><textarea name="FileDesc4" id="FileDesc4" cols="35" rows="3"></textarea></td>
      </tr>
      <tr>
        <td colspan="4" align="center" class="BodyText"><p>&nbsp;
          </p>
          <p>
            <input name="NameExt" type="hidden" id="NameExt" value="<%=request.querystring("NameExt")%>" />
            <input name="UploaderName" type="hidden" id="UploaderName" value="<%=MemberInfo.Fields.Item("lname")%>, <%=MemberInfo.Fields.Item("fname")%>" />
            <input type="submit" name="Submit" value="Submit">
            </p></td>
      </tr>
      </table>
</form></td>
  </tr>
</table>
<% Else %>
<p class="AllCapsTitle">This tool is for Faculty only.</p>
<% End If 
Session.Contents.Remove("SuccessCode")
MemberInfo.Close()
Set MemberInfo = Nothing
Else ' File type specified
%>
<table>
  <tr>
    <td height="20" valign="top" class="PageHeader"><p>Faculty Document  Tool</p>
      </td>
    </tr>
  <tr>
    <td height="30">&nbsp;</td>
  </tr>
  <tr>
    <td align="right" class="BodyText">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left"><a href="../Index.asp" class="AllCapsTitle10">Go to Admin Console</a></td>
        </tr>
      </table>
      </td>
    </tr>
  <tr>
    <td height="30" class="AllCapsTitle">&nbsp;</td>
  </tr>
  <tr>
    <td class="AllCapsTitle">You have not specified a valid file category. Please try again.</td></tr>
</table
><%End If ' File type specified%>
