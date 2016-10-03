 <?php

//header("Last-Modified: " . gmdate( "D, d M Y H:i:s" ) . "GMT" );   
//header("Cache-Control: no-cache, must-revalidate" );

$uploaddir = './picture/';  
//echo "recive a image";  
$file = basename($_FILES['userfile']['name']); 
//echo "/picture/{$file}";   
$uploadfile = $uploaddir . $file;  

$status = -1;

if (file_exists($uploadfile)) {
	// echo 'file already exit'.'<br>';
	$result = unlink($uploadfile);
	if ($result) {
		// echo 'file delete successfully'.'<br>';
		if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {  
			// success
			$status = 0;
			// echo 'file create successfully'.'<br>';
		} else {
			$status = -1;
			// echo 'file create fail'.'<br>';
		}
	} else {
		$status = -1;
		// echo 'file delete fail'.'<br>';
	}
} else {
	if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {  
		// success
		$status = 0;
		// echo 'file create successfully'.'<br>';
	} else {
		$status = -1;
		// echo 'file create fail'.'<br>';
	}
} 





// if (!file_exists($uploadfile)) {
// 	$status = 0;
// } else {
// 	$status = -1;
// }
$output = array('status' => $status);
exit(json_encode($output));

?>