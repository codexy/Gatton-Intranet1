<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../../GattonStyle.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty Performance Review</title>
</head>
<body>
  <?
/**
 * Creator: mhuff0
 * Created: 6/11/14
 * 
 */
/*
 * This file is the home page for the Faculty Performance Review system. It will check the FPR field in directory.userlist to see value - role in system. 1=Regular faculty, 98=Administrative faculty, 99=System admin. Layout and options on page are determined by role.
*/
//include the application header
require_once('ApplicationHeader.html');
//include the configuration file
require_once('../../config.php');
require_once('FPR_PermissionInc.php');
?>
<p class="PageHeader"><?=$_SESSION['usertype']?> Portal - 
<?
if ($_SESSION['FPR']==0) { //Permission to view page?
echo "You do not have permission to view this page.";	
}
else { //Permission to view page?
	if ($_SESSION['FPR']==1) { // Faculty member user?
			$_SESSION['FacultyAD']=	$_SESSION['username'];
			$_SESSION['FacultyFName']=	$_SESSION['LoginFName'];
			$_SESSION['FacultyLName']=	$_SESSION['LoginLName'];
			header("Location:FacultyMemberInfo.php");
		}
		else { // Faculty member user?
			if ($_SESSION['FPR']=99) {
				$_SESSION['FPRDeptID']=$_GET['DeptID'];
			}
			else {
				$_SESSION['FPRDeptID']=$_SESSION['LoginDeptID'];
			}

$sSQL="SELECT * FROM directory.departments WHERE deptid = '".$_SESSION['FPRDeptID']."'";
//echo $sSQL;
$queryDeptInfo = mysql_query($sSQL);
$DeptInfo= mysql_fetch_array($queryDeptInfo);
			

$sSQL="SELECT * FROM directory.employees WHERE dept1id = '".$_SESSION['FPRDeptID']."' AND active=1 AND (position='Faculty' OR position='Lecturer') ORDER BY lname, fname";
//echo $sSQL;
$queryFacultyList = mysql_query($sSQL);
$FacultyList= mysql_fetch_array($queryFacultyList);
$numFacultyList=mysql_num_rows($queryFacultyList);

?>
<?=$DeptInfo['LongName']?></p>
<p class="MediumPrint">Logged in as: <?=$_SESSION['LoginFName']?>&nbsp;<?=$_SESSION['LoginLName']?></p>
<span class="MediumPrint">Number of faculty members=<?=$numFacultyList?></span><br />

<table border="1" cellspacing="2" cellpadding="2">
  <tr>
    <td class="TableColumnHeaders">Faculty Member Name</td>
    <td class="TableColumnHeaders">View Information</td>
  </tr>
<?
while($FacultyList = mysql_fetch_array($queryFacultyList)) {
?>
  <tr>
    <td><?=$FacultyList['lname']?>,&nbsp;<?=$FacultyList['fname']?></td>
    <td align="center"><a href="FacultyMemberInfo.php?FacultyAD=<?=$FacultyList['Username']?>">View</a></td>
  </tr>
<? }
?>
</table>

<p> <a href="NextPage.php">Next Page</a></p>
<?
		} // Faculty member user?
} //Permission to view page?
?>
</body>