<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $db = new DbOperation();

    $response = $db->loadAllCompanies();
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>