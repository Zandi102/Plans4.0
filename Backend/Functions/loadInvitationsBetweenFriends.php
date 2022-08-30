<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $username1 = $_GET['username1'];
    $username2 = $_GET['username2'];

    $db = new DbOperation();

    $response = $db->loadInvitationsBetweenFriends($username1, $username2);
    
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>