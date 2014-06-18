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
Session("User") = Right(Request.ServerVariables("AUTH_USER"),Len(Request.ServerVariables("AUTH_USER")) - (InStr(Request.ServerVariables("AUTH_USER"),"\")))

Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING

sSQL= "Select * From directory.employees Where Username = '"& session("User") & "'"
Set MemberInfo= oConn.Execute(sSQL)
'Show page if member is a faculty member or Melissa
If MemberInfo.Fields.Item("Position").Value = "Faculty" OR MemberInfo.Fields.Item("memberid").Value = 22 OR MemberInfo.Fields.Item("memberid").Value = 1114 OR MemberInfo.Fields.Item("memberid").Value = 1130 Then
%>
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" class="BodyText"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left"><a href="http://gatton.uky.edu/GattonPeople/DetailsFaculty.asp?ID=<%=(MemberInfo.Fields.Item("memberid").Value)%>"></a></td>
        <td align="left"><a href="../Index.asp" class="AllCapsTitle10">Go to Admin Console</a></td>
        </tr>
      </table></td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    </tr>
  
  <tr>
    <td height="20" valign="top" class="PageHeader"><p>Faculty Document  Tool - Update file <%=FileName%>.pdf</p>
      <p><a href="http://gatton.uky.edu/GattonPeople/DetailsFaculty.asp?ID=<%=(MemberInfo.Fields.Item("memberid").Value)%>"></a></p>
      </td>
    </tr>
  <tr>
    <td height="20" valign="top" class="BodyText"><p>To upload an updated file, please use the upload utility below.</p>
  <p class="BodyText">Please browse to the document you want to upload and then click on submit. The document must be in <strong>pdf format</strong>.</p>
  <%
Set fs=Server.CreateObject("Scripting.FileSystemObject")
 If Session("SuccessCode") = 1 Then %>
  <p align="center"><font color="#FF0000">You have attempted to upload a file which is not a pdf file. <br />Please upload a pdf file.</font></p>
  <% End If 
If Session("SuccessCode") = 2 Then %>  
  <p align="center"><font color="#FF0000">Sorry but the following error occurred: <%=Session("ErrorMessage")%></font></p>
  <% End If 
If Session("SuccessCode") = 9 Then %>
  <p align="center"><font color="#FF0000">The upload operation was successfully performed. <br>Your document has been saved on the web server.</font></p>
  <% End If %>
  <form action="ProcessFileUpdateUpload.asp" method="post" enctype="multipart/form-data" name="form1">
    <table border="0" align="center" cellpadding="3" cellspacing="3">
      <tr>
        <td class="BodyText"><strong class="AllCapsTitle">Replacement File: </strong></td>
        <td class="BodyText"><p>
          <INPUT NAME="File1" TYPE="FILE" id="File1" SIZE="40">
          </p>          </td>
      </tr>
      
      <tr>
        <td colspan="2" align="center" class="BodyText"><p>&nbsp;
          </p>
          <p>
            <input name="FileName" type="hidden" id="FileName" value="<%=request.QueryString("FileName")%>" />
            <input name="NameExt" type="hidden" id="FileName" value="<%=request.QueryString("NameExt")%>" />
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
%>
