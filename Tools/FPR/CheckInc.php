<?
/**
 * Creator: mhuff0
 * Created: 6/11/14
 * 
 */
/*
 * This file is the security check for the Faculty Performance Review system. It will check the FPR field in directory.userlist to see value - role in system. 1=Regular faculty, 98=Administrative faculty, 99=System admin. This check will protect any page it is included in.
*/
//include the configuration file
require_once('../../config.php');

//check to make sure session is still active

if (!isset($_SESSION['username'])) {
	echo "You are not logged in. Please log in to continue.";
}
else {
	if (!isset($_SESSION['FPR'])) {
		//check values of FPR variable in directory.userlist
		$sSQL="SELECT * FROM directory.employees LEFT JOIN directory.userlist ON directory.employees.memberid = directory.userlist.employeeid 		WHERE directory.employees.username = '".$_SESSION['username']."'";
		$queryPermissions = mysql_query($sSQL);
		$UserPermissions = mysql_fetch_array($queryPermissions);
		$_SESSION['FPR']=$UserPermissions['FPR'];
	}
}
?>