<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username1 = $_POST['username1'];
    $username2 = $_POST['username2'];

    $db = new DbOperation();

    $result = $db->deleteFriend($username1, $username2);

    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Friend deleted';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Friend not deleted';
    }
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>