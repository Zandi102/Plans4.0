<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username = $_POST['username'];

    $db = new DbOperation();

    $result = $db->removeUser($username);
    
    if ($result == 'Success') {
        $response['error'] = false;
        $response['message'] = 'User removed successfully';
    }
    else{
        $response['error'] = true; 
        $response['message']= 'User remove failed';
    } 
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>