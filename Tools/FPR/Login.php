<?
echo "<p>Login.php ran.</p>";
//check to see if session variable exists, if it does not first time loaded page (this won't run if it is the first time
if (isset($_SESSION['Last_Activity'])) { //time variable exists
	echo "<p>login activity time=".$_SESSION['Last_Activity']."</p>";
	if (time() - $_SESSION['Last_Activity'] > 3) { //time has run out on site session
    // last request was more than 30 minutes ago
    	session_unset();     // unset $_SESSION variable for the run-time 
    	session_destroy();   // destroy session data in storage
		//force IIS login screen
		header('WWW-Authenticate: Basic realm="realm"'); 
		header('HTTP/1.0 401 Unauthorized');
		echo "FORCE LOGON";
	}
	else { //time has run out on site session
		echo "<p>Time hasn't run out.</p>";
	} //time has run out on site session
}
else {
	echo "Session variable doesn't exist!!!";
} //time variable exists
?>
