<?php

$table_info = 'UserInfo';
$table_password = 'UserPassword';
$table_testRecord = 'UserTestRecord';
$table_trainingRecord = 'UserTrainingRecord';

function connectDatabase() {
	$status = -1;
	$con = mysqli_connect("localhost","root","");
	
	if (!$con) {
		// connect to mysql fail
		die('Could not conect: ' .mysql_error());
		$status = 2;
		$info = 'Could not connect to mysql';
	} else {
		// connect to mysql successfully
		//echo ('Connect') . '<br>';
		
		$db_selected = mysqli_select_db($con, "beta0");
		if (!$db_selected) {
			// connect to database beta0 fail
			die('Can\'t use beta0 : ' .mysql_error());
			$status = 3;
			$info = 'Could not connect to database';
		} else {
			// connect to database beta0 successfully
			$status = 0;
		}
	}
	$output = array('status' => $status, 'connect' => $con);
	return $output;
}

function findUserName($con, $name) {
	global $table_password;
	$status = -1;
	$sql_findUser= "select * from $table_password where name = '$name'";
	$result = mysqli_query($con, $sql_findUser);
	//echo 'result: '.$result.'<br>';
	if (mysqli_num_rows($result) == 0) {
		$status = 0;
	} else {
		// user name already exit
		$status = 1;
	}
	return $status;
}

function findUserID($con, $id) {
	global $table_info;
	$status = -1;
	$sql_findUser= "select * from $table_info where id = $id";
	//echo $sql_findUser.'<br>';
	$result = mysqli_query($con, $sql_findUser);
	//echo $result.'<br>';
	//echo 'result: '.$result.'<br>';
	if (mysqli_num_rows($result) == 0) {
		$status = 0;
	} else {
		// user name already exit
		$status = 1;
	}
	return $status;
}

function verifyPassword($con, $name, $password) {
	global $table_password;
	$status = -1;
	$id = 0;
	$sql_get_password = "select * from $table_password where name = '$name'";
	$result = mysqli_query($con, $sql_get_password);
	if (mysqli_num_rows($result) == 0) {
		$status = 4;
		$info = 'User not exit';
	} else {
		//$mysql_password = mysql_result($result, 0);
		$row = mysqli_fetch_array($result);
		$mysql_password = $row['password'];
		//echo 'password: '.$mysql_password.'<br>';
				
		if ($mysql_password != $password) {
			// password incorrect
			$status = 5;
			$info = 'Password incorrect';
		} else {	
			// password correct
			$status = 0;
			$info = 'Password correct';
			$id = $row['id'];
		}
	}
	$output = array('status' => $status, 'id' => $id);
	return $output;
}

function getData($con, $name) {
	$userInfo = getInfo($con, $name);
	$testRecord = getTestRecord($con, $name);
	$trainingRecord = getTrainingRecord($con, $name);
	$data = array('userInfo' => $userInfo, 'testRecord' => $testRecord, 'trainingRecord' => $trainingRecord);
	return $data;
}

// get user basic info
function getInfo($con, $id) {
	global $table_info;
	$userInfo = array();
	$sql_getInfo = "select * from $table_info where id = $id";
	$result = mysqli_query($con, $sql_getInfo);
	$status = -1;
	if (mysqli_num_rows($result) != 0) {
		$status = 0;
		$userInfo = mysqli_fetch_array($result);
		//print_r($userInfo);
	}
	return array('status' => $status, 'userInfo' => $userInfo);
}

// get user test record
function getTestRecord($con, $id) {
	global $table_testRecord;
	$testRecord = array();
	$sql_getTestRecord = "select * from $table_testRecord where id = $id";
	$result = mysqli_query($con, $sql_getTestRecord);
	// get all test record
	$count = 0;
	// $flag = 0;
	while($row = mysqli_fetch_array($result)) {
		//print_r($row);
		// $temp = array('$flag' => $row)
		$testRecord["'$count'"] = $row;
		$count = $count + 1;
		// $flag = $flag + 1;
		// if ($flag == 4) {
		// 	$count = $count + 1;
		// 	$flag = 0;
		// }
		//$testRecord[] = $row;
	}
	return array('testRecord' => $testRecord);
}

function addTestRecord($con, $id, $record) {
	global $table_testRecord;
	$status = 0;
	$timestamp = $record[4][0];
	$title = $record[4][1];
	for ($count = 0; $count < 4; $count++) {
		$lng = $record[$count][0];
		$mv = $record[$count][1];
		$area = $record[$count][2];
		$lng_a = $record[$count][3];
		$lngx = $record[$count][4];
		$lngy = $record[$count][5];

		//$sql_addTestRecord = "insert into $table_testRecord values($id,$count,'$record[$count][0]','$record[$count][1]','$record[$count][2]','$record[$count][3]','$record[$count][4]','$record[$count][5]','$record[4][0]','$record[4][1]'";
		$sql_addTestRecord = "insert into $table_testRecord values($id,$count,'$lng','$mv','$area','$lng_a','$lngx','$lngy','$timestamp','$title')";

		//print_r($sql_addTestRecord);

		$result = mysqli_query($con, $sql_addTestRecord);
		if (!$result) {
			// print_r("insert error");
			$status = -1;
		}
	}
	return $status;
}

function deleteTestRecord($con, $id, $timestamp) {
	global $table_testRecord;
	$status = 0;
	$sql_deleteTestRecord = "delete from $table_testRecord where id=$id and timestamp='$timestamp'";
	//print_r($sql_deleteTestRecord);
	$result = mysqli_query($con, $sql_deleteTestRecord);
	//print_r($result);
	if (!$result) {
		$status = -1;
	}
	return $status;
}

function getTrainingRecord($con, $id) {
	global $table_trainingRecord;
	$trainingRecord = array();
	$sql_getTrainingRecord = "select * from $table_trainingRecord where id = $id";
	$result = mysqli_query($con, $sql_getTrainingRecord);
	// get all training record
	$count = 0;
	while($row = mysqli_fetch_array($result)) {
		//print_r($row);
		// $trainingRecord[] = $row;
		$trainingRecord["'$count'"] = $row;
		$count = $count + 1;
	}
	return array('trainingRecord' => $trainingRecord);
}

function addTrainingRecord($con, $id, $record) {
	global $table_trainingRecord;
	$status = 0;
	$totalTime = $record[0];
	$meanTime = $record[1];
	$leastTime = $record[2];
	$mostTime = $record[3];
	$failNumber = $record[4];
	$successNumber = $record[5];
	$timestamp = $record[6];
	$title = $record[7];
	$sql_addTtrainingRecord = "insert into $table_trainingRecord values($id,'$totalTime','$meanTime','$leastTime','$mostTime',$failNumber,$successNumber,'$timestamp','$title')";
	$result = mysqli_query($con, $sql_addTtrainingRecord);
	if (!$result) {
		$status = -1;
	}

	return $status;
}

function deleteTrainingRecord($con, $id, $timestamp) {
	global $table_trainingRecord;
	$status = 0;
	$sql_deleteTrainingRecord = "delete from $table_trainingRecord where id=$id and $timestamp='$timestamp'";
	$result = mysqli_query($con, $sql_deleteTrainingRecord);
	if (!$result) {
		$status = -1;
	}
	return $status;
}

function updateInfo($con, $id, $name, $sex, $age, $height, $weight_main, $weight_fraction, $weight, $bust, $waist, $hip) {
	global $table_info;
	$sql_updateInfo = "update $table_info set name='$name', sex=$sex, age=$age, height=$height, weight_main=$weight_main, weight_fraction=$weight_fraction, weight=$weight, bust=$bust, waist=$waist, hip=$hip where id=$id";
	$result = mysqli_query($con,$sql_updateInfo);
	if ($result) {
		$status = 0;
	} else {
		$status = 8;	// update userInfo fail
	}
	return $status;
}

function changeNameInPassword($con, $id, $name) {
	global $table_password;
	$sql_changeName = "update $table_password set name = '$name' where id = $id";
	$result = mysqli_query($con,$sql_changeName);
	if ($result) {
		$status = 0;
	} else {
		$status = 9;	// change user name in password table fail
	}
	return $status;
}

function insertInfo($con, $id, $name, $sex, $age, $height, $weight_main, $weight_fraction, $weight, $bust, $waist, $hip) {
	global $table_info;
	$sql_insertInfo = "insert into $table_info(id, name, sex, age, height, weight_main, weight_fraction, weight, bust, waist, hip) values($id, '$name', $sex, $age, $height, $weight_main, $weight_fraction, $weight, $bust, $waist, $hip)";
	$result = mysqli_query($con, $sql_insertInfo);
	if ($result) {
		$status = 0;
	} else {
		$status = 7;	// insert userInfo fail
	}
}



?>










