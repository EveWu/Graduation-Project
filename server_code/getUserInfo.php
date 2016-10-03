<?php

include 'mysql.php';

$output = array();
$id = @$_GET['id'] ? $_GET['id'] : 0;
$status = -1;
$info = array();
if ($id == 0) {
	$status = -1;
} else {
	$connect = connectDatabase();
	$status = $connect['status'];
	// connect to database successfully
	if ($status == 0) {	
		$con = $connect['connect'];
		$result = getInfo($con, $id);
		$status = $result['status'];
		if ($status == 0) {
			$info = $result['userInfo'];
		} else {
			$status = -1;
		}
	}
	mysqli_close($con);
}

exit(json_encode(array('status' => $status, 'userInfo' => $info)));

?>