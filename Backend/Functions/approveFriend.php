<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username1 = $_POST['username1'];
    $username2 = $_POST['username2'];
   
    $db = new DbOperation();

    $result = $db->approveFriend($username1, $username2);
    
    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Request is now approved';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Request is not approved';
    }

} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>