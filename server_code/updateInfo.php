<?php

include 'mysql.php';

//$_POST = file_get_contents("php://_POST");
//echo 'request: '.$request.'<br>';
//$_POST = json_decode($request,TRUE);
//echo '_POST: '.$_POST.'<br>';
//print_r($_POST);
$id = $_POST['id'];
$name = $_POST['name'];
$sex = $_POST['sex'];
$age = $_POST['age'];
$height = $_POST['height'];
$weight_main = $_POST['weight_main'];
$weight_fraction = $_POST['weight_fraction'];
$weight = $_POST['weight'];
$bust = $_POST['bust'];
$waist = $_POST['waist'];
$hip = $_POST['hip'];

//echo 'id: '.$id.'<br>';

$connect = connectDatabase();
$status = $connect['status'];
// connect to database successfully
if ($status == 0) {	
	$con = $connect['connect'];

	$status = findUserName($con, $name);
	if ($status == 0) {
		$status = changeNameInPassword($con, $id, $name);
		if ($status == 0) {
			$status = findUserID($con, $id);
			// user have no record before   
			if ($status == 0) {
				$status = insertInfo($con, $id, $name, $sex, $age, $height, $weight_main, $weight_fraction, $weight, $bust, $waist, $hip);
			} else {
				$status = updateInfo($con, $id, $name, $sex, $age, $height, $weight_main, $weight_fraction, $weight, $bust, $waist, $hip);
			}
		} else {
			$status = -1;
		}
	} else {
		$status = 1;	// the name has already exit
	}
}
mysqli_close($con);

$output = array('status' => $status);
exit(json_encode($output));

?>
