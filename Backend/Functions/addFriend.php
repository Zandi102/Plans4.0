<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username1 = $_POST['username1'];
    $username2= $_POST['username2'];
   
    $db = new DbOperation();

    $result = $db->addFriend($username1, $username2);
    
    if($result == true){
        $response['error'] = false;
        $response['message'] = 'User is now added and pending for approval';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Failed to add user';
    }

} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>