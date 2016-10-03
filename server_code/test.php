<?php
$output = array();
$name = @$_GET['name'] ? $_GET['name'] : '';
$password = @$_GET['password'] ? $_GET['password'] : '';
$output = array('name' => $name, 'password' => $password);
exit(json_encode($output));
?>