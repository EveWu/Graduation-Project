<?php

include 'mysql.php';

$output = array();
$name = @$_GET['name'] ? $_GET['name'] : '';
$password = @$_GET['password'] ? $_GET['password'] : '';
$status = -1;
$id = 0;
$data = array();


if (empty($name) || empty($password)) {
	echo('name or password empty').'<br>';
	$status = 1;
	$info = 'empty user name or password';
} else {
	$connect = connectDatabase();
	$status = $connect['status'];
	// connect to database successfully
	if ($status == 0) {	
		$con = $connect['connect'];
		$result = verifyPassword($con, $name, $password);
		$status = $result['status'];
		// password correct
		if ($status == 0) {
			$id = $result['id'];
		}
	}
	mysqli_close($con);
}

$output = array('status' => $status, 'id' => $id);
exit(json_encode($output));

?>