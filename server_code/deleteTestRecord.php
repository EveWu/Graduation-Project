<?php

include 'mysql.php';

$output = array();
$id = @$_GET['id'] ? $_GET['id'] : 0;
$timestamp = @$_GET['timestamp'] ? $_GET['timestamp'] : '';
$status = -1;
if ($id == 0) {
	$status = -1;
} else {
	$connect = connectDatabase();
	$status = $connect['status'];
	// connect to database successfully
	if ($status == 0) {	
		$con = $connect['connect'];
		$status = deleteTestRecord($con, $id, $timestamp);
	}
	mysqli_close($con);
}

exit(json_encode(array('status' => $status)));

?>