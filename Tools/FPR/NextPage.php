<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../../GattonStyle.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty Performance Review</title>
</head>
<body>
<p>
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
<p class="PageHeader"><?=$_SESSION['usertype']?> Portal</p>
<p class="MediumPrint">Logged in as: <?=$_SESSION['LoginFName']?>&nbsp;<?=$_SESSION['LoginLName']?></p>
<?
if ($_SESSION['FPR']==0) {
echo "You do not have permission to view this page.";	
}
else {
?>
Faculty Member: <?=$_SESSION['FACULTYID']?>, <?=$_SESSION['FacultyFName']?>&nbsp;<?=$_SESSION['FacultyLName']?>

<p> <a href="Index.php">Go back to Index</a></p>
<?
}
?>
</body>
</html>