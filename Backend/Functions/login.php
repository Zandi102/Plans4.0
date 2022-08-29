<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username = $_POST['username'];
    $password= $_POST['password'];
   
    $db = new DbOperation();

    $result = $db->login($username, $password);
    
    if($result == true){
        $response['error'] = false;
        $response['message'] = 'login successful';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'login unsuccessful';
    }

} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>