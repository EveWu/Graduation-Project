<?php

include 'mysql.php';

$output = array();
$id = @$_GET['id'] ? $_GET['id'] : 0;
$status = -1;
$testRecord = array();
if ($id == 0) {
	$status = -1;
} else {
	$connect = connectDatabase();
	$status = $connect['status'];
	// connect to database successfully
	if ($status == 0) {	
		$con = $connect['connect'];
		$result = getTestRecord($con, $id);
		$testRecord = $result['testRecord'];
		// $status = $result['status'];
		// if ($status == 0) {
		// 	$testRecord = $result['testRecord'];
		// } else {
		// 	$status = -1;
		// }
	}
	mysqli_close($con);
}

exit(json_encode(array('testRecord' => $testRecord)));

?>