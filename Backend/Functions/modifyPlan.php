<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $plan_id = $_POST['plan_id'];
    $plan_name = $_POST['plan_name'];
    $endTime = $_POST['endTime'];
    $startTime = $_POST['startTime'];
    $date = $_POST['date'];
    $description = $_POST['description'];
    $longitude = $_POST['longitude'];
    $latitude = $_POST['latitude'];

    $db = new DbOperation();

    $result = $db->modifyPlan($plan_id, $plan_name, $endTime, $startTime, $date, $description, $longitude, $latitude);
    
    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Modification sucessful';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Did not modify';
    }

} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>