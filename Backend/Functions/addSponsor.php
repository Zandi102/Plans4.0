<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $amount= $_POST['amount'];
    $compID= $_POST['compID'];
    $plan_id= $_POST['plan_id'];

    $db = new DbOperation();

    $result = $db-> addSponsor($compID, $plan_id, $amount);

    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Sponsor Created Successfully';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Sponsor Creation Failed';
    }
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>