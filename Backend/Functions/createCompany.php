<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $compName = $_POST['compName'];


    $db = new DbOperation();

    $result = $db-> createCompany($compName);

    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Company Created Successfully';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Company Creation Failed';
    }
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>