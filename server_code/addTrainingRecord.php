<?php

include 'mysql.php';

$id = $_POST['id'];
$recordStr = $_POST['record'];
$record = json_decode($recordStr,TRUE);
// $totalTime = $_POST['totalTime'];
// $meanTime = $_POST['meanTime'];
// $leastTime = $_POST['leastTime'];
// $mostTime = $_POST['mostTime'];
// $failNumber = $_POST['failNumber'];
// $successNumber = $_POST['successNumber'];
// $timestamp = $_POST['timestamp'];
// $title = $_POST['title'];
//$record = $_POST['record'];

$connect = connectDatabase();
$status = $connect['status'];
// connect to database successfully
if ($status == 0) {	
	$con = $connect['connect'];
	$status = addTrainingRecord($con, $id, $record);
}
mysqli_close($con);

$output = array('status' => $status);
exit(json_encode($output));

?>
