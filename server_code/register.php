<?php
$output = array();
$request = file_get_contents("php://input");
$arr = json_decode($request,TRUE);
$ = $arr['data1']?$arr['data1']:'';
$data2 = $arr['data2']?$arr['data2']:'';
$data3 = $arr['data3']?$arr['data3']:'';
$data4 = $arr['data4']?$arr['data4']:'';
$data5 = $arr['data5']?$arr['data5']:'';
$index = $arr['index']?$arr['index']:1;

?>