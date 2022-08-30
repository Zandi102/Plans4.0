<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $username = $_GET['username'];

    $db = new DbOperation();

    $response = $db->loadUserPlans($username);
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>