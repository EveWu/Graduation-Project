<?php

include 'mysql.php';

$status = -1;
$name = @$_GET['name'] ? $_GET['name'] : '';
if (empty($name)) {
	echo('name empty').'<br>';
} else {
	$connect = connectDatabase();
	$status = $connect['status'];
	// connect to database successfully
	if ($status == 0) {	
		$con = $connect['connect'];
		$status = findUser($con, $name);
	}
	mysqli_close($con);
}
echo 'name: '.$name.'<br>';
echo $status.'<br>';
exit(json_encode($status));

?>