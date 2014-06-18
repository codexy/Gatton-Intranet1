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
<p class="PageHeader"><?=$_SESSION['FacultyFName']?>&nbsp;<?=$_SESSION['FacultyLName']?> - D.O.E.</p>
<p class="MediumPrint">Logged in as: <?=$_SESSION['LoginFName']?>&nbsp;<?=$_SESSION['LoginLName']?></p>
<?
if ($_SESSION['FPR']==0) { //Permission to view page?
echo "You do not have permission to view this page.";	
}
else { //Permission to view page?
	if ($_SESSION['FPR']==1) { // Faculty member user?
			$_SESSION['FacultyAD']=	$_SESSION['username'];
		}
		else { // Faculty member user?
			if (isset($_GET['FacultyAD'])) { //URL parameter FacultyAD set?
			$_SESSION['FacultyAD']=	$_GET['FacultyAD'];
			}
			else { //URL parameter FacultyAD set?
				$error="No faculty member was specified";
			} //URL parameter FacultyAD set?
		} // Faculty member user?

if (isset($error)) { //Page errored out
	echo $error;
}
else { //Page errored out
//query directory.employees to find information about faculty member
$sSQL="SELECT * FROM directory.employees WHERE username = '".$_SESSION['FacultyAD']."'";
//echo $sSQL;
$queryFacultyInfo = mysql_query($sSQL);
$FacultyInfo= mysql_fetch_array($queryFacultyInfo);
$_SESSION['FacultyFName']=$FacultyInfo['fname'];
$_SESSION['FacultyLName']=$FacultyInfo['lname'];
//query facultyperfrev.doe to find information on doe
$sSQL="SELECT * FROM facultyperfrev.doe WHERE facultyad = '".$_SESSION['FacultyAD']."' ORDER BY ReviewYear DESC";
//echo $sSQL;
$queryDOE = mysql_query($sSQL);
$numDOE=mysql_num_rows($queryDOE);
?>
<table width="800" border="1" cellspacing="2" cellpadding="2">
  <tr>
    <td align="center" class="TableColumnHeaders">Review Year</td>
    <td align="center" class="TableColumnHeaders">Research %</td>
    <td align="center" class="TableColumnHeaders">Teaching %</td>
    <td align="center" class="TableColumnHeaders">Service %</td>
    <td align="center" class="TableColumnHeaders">Administrative %</td>
    <td align="center" class="TableColumnHeaders">View/Edit Scores</td>
  </tr>
<?
  while($DOE = mysql_fetch_array($queryDOE)) { //loop through DOE
?>
  <tr>
    <td align="center"><?=$DOE['ReviewYear']?>&nbsp;</td>
    <td align="center"><?=$DOE['ResearchPercent']?>%&nbsp;</td>
    <td align="center"><?=$DOE['TeachingPercent']?>%&nbsp;</td>
    <td align="center"><?=$DOE['ServicePercent']?>%&nbsp;</td>
    <td align="center"><?=$DOE['AdminPercent']?>%&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
<? } //loop through DOE ?>
</table>
<?
} //Page errored out
} //Permission to view page?
?>
</body>