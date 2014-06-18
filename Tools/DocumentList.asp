<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../GattonStyle.css" rel="stylesheet" type="text/css" />
<title>Dean's Office Administration Tools</title>
</head>

<body>
<!--#include file="ApplicationHeader.html" -->
<!--#include file="CheckInc.asp" -->
<p>&nbsp;</p>
<p>
  <%  
Session("User") = Right(Request.ServerVariables("AUTH_USER"),Len(Request.ServerVariables("AUTH_USER")) - (InStr(Request.ServerVariables("AUTH_USER"),"\")))
sSQL="SELECT * FROM documentuploads.categories WHERE NameExt='"&request.QueryString("NameExt")&"'"
Set DocumentInfo= oConn.Execute(sSQL, NumofRec)

If NumofRec>0 Then ' File type specified

sSQL="SELECT * FROM documentuploads.categories WHERE NameExt='"&request.QueryString("NameExt")&"'"
Set DocumentInfo= oConn.Execute(sSQL)

sSQL="SELECT * FROM documentuploads.uploadedfiles WHERE Category='"&request.QueryString("NameExt")&"' AND Year='"&request.QueryString("Year")&"' ORDER BY FileName ASC"
Set DocumentList= oConn.Execute(sSQL,NumofFiles)

sSQL= "Select * From directory.employees Where Username = '"& session("User") & "'"
Set MemberInfo= oConn.Execute(sSQL)
%>
  <p class="PageHeader">Faculty Documents - <%=DocumentInfo.Fields.Item("Type")%>, Year <%=request.QueryString("Year")%></p>
  <p class="AllCapsTitle10">Total Number of Documents:&nbsp;<%=NumofFiles%></p>
  <table width="1200" border="0">
    <tr>
      <td class="AllCapsTitle10"><a href="../Index.asp">Go to Admin Console</a></td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <table width="1000" border="1" cellspacing="2" cellpadding="2">
    <tr>
      <td width="25%" class="TableColumnHeaders">File Name</td>
      <td class="TableColumnHeaders">Date Uploaded</td>
      <td class="TableColumnHeaders">Faculty Member</td>
      <td width="40%" class="TableColumnHeaders">Description</td>
    </tr>
<% If NumofFiles>0 Then 
X=1
Owner=DocumentList.Fields.Item("UploadedBy")
Do While Not DocumentList.EOF 
If Owner=DocumentList.Fields.Item("UploadedBy") Then
X=X
Else
X=X+1
Owner=DocumentList.Fields.Item("UploadedBy")
End If
%>    
    <tr>
      <td width="30%" <%If (X mod 2)=1 Then%>class="RowHighlight"<%End If%>><a href="http://gatton.inet.uky.edu/documents/<%=DocumentList.Fields.Item("FileName")%>" target="_blank"><%=DocumentList.Fields.Item("FileName")%></a>&nbsp;</td>
      <td <%If (X mod 2)=1 Then%>class="RowHighlight"<%End If%>><%=DocumentList.Fields.Item("DateUploaded")%>&nbsp;</td>
      <td <%If (X mod 2)=1 Then%>class="RowHighlight"<%End If%>><%=DocumentList.Fields.Item("UploadedBy")%>&nbsp;</td>
      <td <%If (X mod 2)=1 Then%>class="RowHighlight"<%End If%>><%=DocumentList.Fields.Item("Description")%></td>
    </tr>
<% 
DocumentList.MoveNext
Loop
Else %>
	<tr><td colspan="4">There are currently no files in this category.</td></tr>
<% End If 
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
</table>
<%End If ' File type specified%>
  </table>
  <p class="PageHeader">&nbsp;</p> 
  <!--#include file="Check2Inc.asp" --></p>
</body>
</html>
