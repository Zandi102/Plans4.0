<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $plan_name = $_GET['plan_name'];
    $address = $_GET['address'];
    $username = $_GET['username'];

    $db = new DbOperation();

    $response = $db->getPlanID($plan_name, $address, $username);
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>