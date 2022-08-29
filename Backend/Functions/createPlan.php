<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username = $_POST['username'];
    $description = $_POST['description'];
    $plan_name = $_POST['plan_name'];
    $startTime = $_POST['startTime'];
    $endTime = $_POST['endTime'];
    $date = $_POST['date'];
    $address = $_POST['address'];
    //$longitude = $_POST['longitude'];
    //$latitude = $_POST['latitude'];

    $db = new DbOperation();

    $result = $db->createPlan($username, $description, $plan_name, $startTime, $endTime, $date, $address);

    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Plan Created Successfully';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Plan Creation Failed';
    }
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>