<?php

include 'mysql.php';

//$request = file_get_contents("php://input");
//$arr = json_decode($request,TRUE);
//print_r($result);
//print_r($arr);
$id = $_POST['id'];
$recordStr = $_POST['record'];
$record = json_decode($recordStr,TRUE);
// print_r($record);
//$id = $_POST['id'];
// $lng = $_POST['lng'];
// $mv = $_POST['mv'];
// $area = $_POST['area'];
// $lng_a = $_POST['lng_a'];
// $lngx = $_POST['lngx'];
// $lngy = $_POST['lngy'];
// $timestamp = $_POST['timestamp'];
// $title = $_POST['title'];
//$input = $_POST['record'];

//$record = explode(,, string)

$connect = connectDatabase();
$status = $connect['status'];
// connect to database successfully
if ($status == 0) {	
	$con = $connect['connect'];
	//$status = addTestRecord($con, $id, $lng, $mv, $area, $lng_a, $lngx, $lngy, $timestamp, $title);
	$status = addTestRecord($con, $id, $record);
}
mysqli_close($con);

$output = array('status' => $status);
exit(json_encode($output));

?>
