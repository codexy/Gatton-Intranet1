<?php
/**
 * Creator: dscott0
 * Created: 2/20/14
 * 
 */

//include server and database connection information
include '../connections/mysql.php';

//collect username from post variable
$username = $_POST['Username'];

//update the database (because the upload option is being used instead of the link to webpage option)
mysql_query("UPDATE directory.employees SET VitaOther=0, Vita=Null WHERE Username= '$username'");

//select faculty information to use in the renaming of the uploaded file
$facultyResult = mysql_query("SELECT * FROM directory.employees WHERE Username = '$username'");
$facultyRow = mysql_fetch_array($facultyResult);



//Collect the uploaded file, check that the type is pdf and that the size is limited to 1MB.  Then rename and save the file.
if (is_uploaded_file($_FILES['File1']['tmp_name'])) {

    //if there is an error, save it as a string to be passed to the form on redirect as a url parameter
    if ($_FILES['File1']['error'] > 0) {
        $successCode = 2;     //corresponds to an upload error message
        $errorMessage = $_FILES['File1']['error'];
    }

    //get the extension(type) and size
    $fileExtension = findexts($_FILES['File1']['name']);
    $fileSize = $_FILES['File1']['size'] / 1024;

    //create the file name: [LastName][FirstName].pdf
    $lastName = $facultyRow['lname'];
    $firstName = $facultyRow['fname'];
    $firstInitial = substr($firstName, 0, 1);
    $fileName = $lastName . $firstInitial . '.' . $fileExtension;

    //create the target (path plus filename)
    $filePath = "D:\\Inetpub\\wwwroot\\Vitas\\";
    $fileTarget = $filePath . $fileName;

    //write the file to folder, overwriting any previous version.  Only do so if the extension is pdf and if the size is under 1MB
    if($fileSize > 5500) {
        $successCode = 3;  //corresponds to "file too large" error message on redirect
        $errorMessage = 'File chosen is too large';
    }
    else if($fileExtension != 'pdf') {
        $successCode = 1;  //corresponds to "wrong format" error message on redirect
        $errorMessage = 'Please choose a file of type pdf';
    }
    else {
        $tmp_name = $_FILES['File1']['tmp_name'];
        move_uploaded_file($tmp_name, $fileTarget);
        $successCode = 9;
        $errorMessage = 'None';
    }

}
else {
    //no file was uploaded
    $successCode = 2;
    $errorMessage = "Please select a file for upload before submitting";
}

//function to pull the extension off of an uploaded file name
function findexts ($filename)
{
    $filename = strtolower($filename);
    $exts = pathinfo($filename, PATHINFO_EXTENSION);
    return $exts;
}
echo "*****";
?>
<script type='text/javascript'>
    window.location = 'http://gatton.inet.uky.edu/tools/FacultyVita.asp?SuccessCode=<?=$successCode?>&ErrorMessage=<?=$errorMessage?>';
</script>
















