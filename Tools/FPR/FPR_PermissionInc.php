<?
//*********************************************************************
//set session variable that determines if user has permission to view this section
//*********************************************************************
//if either condition exists, query database again to check permissions
if ((isset($_SESSION['FPR']) && (time()-$_SESSION['FPRTime']>5)) or !isset($_SESSION['FPR'])) { //session FPRTime set?
//check values of FPR variable in directory.userlist (done every time home page loads)
$sSQL="SELECT * FROM directory.employees LEFT JOIN directory.userlist ON directory.employees.memberid = directory.userlist.employeeid WHERE directory.employees.username = '".$_SESSION['username']."'";
$queryPermissions = mysql_query($sSQL);
$UserPermissions = mysql_fetch_array($queryPermissions);
$_SESSION['FPR']=$UserPermissions['FPR'];
$_SESSION['FPRTime']=time();
//set generic page title
switch($_SESSION['FPR']) { //case select
	case 1:
	  $_SESSION['usertype']="Faculty Member";
	  break;
	case 98:
	  $_SESSION['usertype']="Department Chair";
	  break;
	case 99:
	  $_SESSION['usertype']="Administrator";
	  break;
	case 0:
	  $_SESSION['usertype']="Faculty Performance Review";
	  break;
} //case select
} //session FPRTime set?
?>