<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml">
<!--#include file="../Connections/MySQL.asp" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../GattonStyle.css" rel="stylesheet" type="text/css" />
</head>

<body>
<!--#include file="ApplicationHeader.html" -->
<table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="850" height="40" colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" valign="top"><%  
Session("User") = Right(Request.ServerVariables("AUTH_USER"),Len(Request.ServerVariables("AUTH_USER")) - (InStr(Request.ServerVariables("AUTH_USER"),"\")))
Dim username
username = Session("User")

'collect the url variables passed to this page if they are set
If Len(request.querystring("SuccessCode")) > 0 Then
    dim successCode
    successCode= request.querystring("SuccessCode")
End If
If Len(request.querystring("ErrorMessage")) > 0 Then
    dim errorMessage
    errorMessage = request.querystring("ErrorMessage")
End If

Set oConn = Server.CreateObject("ADODB.Connection")
oConn.Open = MM_MySQL_STRING

sSQL= "Select * From directory.Employees Where Username = '"& session("User") & "'"
Set MemberInfo= oConn.Execute(sSQL)
%>
<% If MemberInfo.Fields.Item("Position").Value = "Faculty" OR MemberInfo.Fields.Item("memberid").Value = 22 OR MemberInfo.Fields.Item("memberid").Value = 1114 Then
%>
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" class="BodyText"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left"><a href="http://gatton.uky.edu/GattonPeople/DetailsFaculty.asp?ID=<%=(MemberInfo.Fields.Item("memberid").Value)%>"></a></td>
        <td align="right"><a href="../Index.asp" class="AllCapsTitle10">Go to Admin Console</a></td>
        </tr>
      </table></td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    </tr>
  
  <tr>
    <td height="20" valign="top" class="PageHeader"><p>Faculty Web Vita  Tools</p>
      <p><a href="http://gatton.uky.edu/GattonPeople/DetailsFaculty.asp?ID=<%=(MemberInfo.Fields.Item("memberid").Value)%>"></a></p>
      </td>
    </tr>
  <tr>
    <td height="20" valign="top" class="BodyText">
  <% 
VitaOnFile = 0
If MemberInfo.Fields.Item("VitaOther").Value = "1" Then 
  VitaOnFile = 1
End If
Set fs=Server.CreateObject("Scripting.FileSystemObject")
If (fs.FileExists("d:\inetpub\wwwroot\Vitas\" & (MemberInfo.Fields.Item("lname").Value) & Left(MemberInfo.Fields.Item("fname").Value,1) & ".pdf") = true) Then 
  VitaOnFile = 2
End If
If VitaOnFile = 1 Then
%>			
  <p><span class="AllCapsTitle"><a href="<%=(MemberInfo.Fields.Item("Vita").Value)%>" target="_blank">Vita on File</a></span> (You are currently using Option 2: Web Link. If you wish to change this use, one of the options below.)</p>		
  <%
End If 
If VitaOnFile = 2 Then
%>
  <p><span class="AllCapsTitle"><a href="http://gatton.uky.edu/vitas/<%=(MemberInfo.Fields.Item("lname").Value)%><%=Left(MemberInfo.Fields.Item("fname").Value,1)%>.pdf" target="_blank">Vita on File</a></span> (You are currently using Option 1: Uploaded PDF. If you wish to change this, use one of the options below.  If you wish to upload a new version of your vita, simply upload the file below and the current vita will be replaced.)</p>
  <% End If
If VitaOnFile = 0 Then
%>
  <p class="AllCapsTitle">There is currently no vita on file for you</p>
  <% End If %>
  <p>&nbsp;</p>
  <p class="AllCapsTitle">OPTION 1: Use the upload utility to upload a pdf copy of your vita to the general storage area</p>
  <p class="BodyText">Please browse to your current vita and then click on submit. Your vita must be in pdf format. If your vita is not in pdf format, read these instructions on <a href="CreatePDF.asp" target="_blank">how to create a pdf file</a>.</p>
  <%
Set fs=Server.CreateObject("Scripting.FileSystemObject")
If (fs.FileExists("d:\inetpub\wwwroot\Vitas\" & (MemberInfo.Fields.Item("lname").Value) & Left(MemberInfo.Fields.Item("fname").Value,1) & ".pdf") = true) Then %> 
  <p class="AllCapsTitle10"><a href="VitaDeleteConfirm.asp">Remove the Vita Currently on File</a></p>
  <% End If %>
  <% 'If Session("SuccessCode") = 1 Then
     If successCode = 1 Then
    %>
  <p align="center"><font color="#FF0000">You have attempted to upload a file which is not a pdf file. <br />Please upload a pdf file.</font></p>
  <% End If 
'If Session("SuccessCode") = 2 Then
 If successCode = 2 Then
%>
  <!--<p align="center"><font color="#FF0000">Sorry but the following error occurred: <%=Session("ErrorMessage")%></font></p>-->
  <p align="center"><font color="#FF0000">Sorry but the following error occurred: <%=errorMessage%></font></p>
  <% End If
'If Session("SuccessCode") = 9 Then
If successCode = 9 Then
%>
  <p align="center"><font color="#FF0000">The upload operation was successfully performed. <br>Your vita has been saved on the web server.</font></p>
  <% End If
  If successCode = 3 Then
  %>
  <p align="center"><font color="#FF0000">The pdf you are trying to upload is too large.</font></p>
  <% End If %>
  <form action="VitaUpload.php" method="post" enctype="multipart/form-data" name="form1">
    <table border="0" align="center" cellpadding="3" cellspacing="3">
      <tr>
        <td valign="top" class="BodyText"><strong class="AllCapsTitle">Vita: </strong></td>
        <td class="BodyText"><p>
          <INPUT NAME="File1" TYPE="FILE" id="File1" SIZE="40">
          </p>          </td>
        </tr>
      
      <tr>
        <td colspan="2" align="center" class="BodyText"><p>&nbsp;
          </p>
          <p>
            <input type="hidden" name="Username" value="<%=username%>">
            <input type="submit" name="Submit" value="Submit">
            </p></td>
        </tr>
      </table>
  </form></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    </tr>
  <tr><td><p align="center" class="PageHeaderBlack">OR</p>
    <p class="AllCapsTitle">Option 2: Link to your vita on your personal website or other web server</p>
    <p>(Notes: If option 2 is set up, it will override option 1 and any pdf vita you uploaded in the past will be removed from the server. For the URL, type in the entire URL for the vita including &quot;http://&quot;.)</p>
    <form id="form2" name="form2" method="post" action="RecordVitaURL.asp">
      <table border="0" align="center" cellpadding="3" cellspacing="3">
        <tr>
          <td align="right" class="AllCapsTitle"><input name="VitaOther" type="radio" id="VitaOther" value="0" <% If MemberInfo.fields("VitaOther").Value = 1 Then %> 
              <% End If %>
              /></td>
          <td class="BodyText">I want to remove my link to another URL in sharing my vita.</td>
          </tr>
        <tr>
          <td align="right" class="AllCapsTitle">
            <input name="VitaOther" type="radio" id="VitaOther" value="1" <% If MemberInfo.fields("VitaOther").Value = 1 Then %> checked="checked" 
              <% End If %>
              />           </td>
          <td class="BodyText">I want to link to the below URL to share my vita.</td>
          </tr>
        <tr>
          <td class="AllCapsTitle">Vita URL:</td>
          <td><label>
            <input name="VitaURL" type="text" id="VitaURL" value="<%=MemberInfo.fields("Vita").Value%>" size="70" />
            </label></td>
          </tr>
        <tr>
          <td colspan="2" align="center"><label>
            <br />
            <input type="submit" name="Submit" id="Submit" value="Submit" />
            </label></td>
          </tr>
        </table>
      </form>      <p>&nbsp;</p></td></tr>
</table>
<% Else %>

<p class="AllCapsTitle">This vita tool is for Faculty only.</p>
<% End If %></td>
  </tr>
</table>
<%
Session.Contents.Remove("SuccessCode")
MemberInfo.Close()
Set MemberInfo = Nothing
%>
</body>
</html>
