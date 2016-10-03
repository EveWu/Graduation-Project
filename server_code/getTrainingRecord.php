<?php

include 'mysql.php';

$output = array();
$id = @$_GET['id'] ? $_GET['id'] : 0;
$status = -1;
$trainingRecord = array();
if ($id == 0) {
	$status = -1;
} else {
	$connect = connectDatabase();
	$status = $connect['status'];
	// connect to database successfully
	if ($status == 0) {	
		$con = $connect['connect'];
		$result = getTrainingRecord($con, $id);
		$trainingRecord = $result['trainingRecord'];
		// $status = $result['status'];
		// if ($status == 0) {
		// 	$trainingRecord = $result['trainingRecord'];
		// } else {
		// 	$status = -1;
		// }
	}
	mysqli_close($con);
}

exit(json_encode(array('trainingRecord' => $trainingRecord)));

?>