<?php


//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $plan_id = $_POST['plan_id'];

    $db = new DbOperation();

    $result = $db->deletePlan($plan_id);

    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Plan deleted Successfully';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Deletion Failed';
    }
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>