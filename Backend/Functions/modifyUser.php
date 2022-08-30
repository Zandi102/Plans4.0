<?php

//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $username = $_POST['username'];
    $password = $_POST['password'];
    $age = $_POST['age'];
    $phone = $_POST['phone'];
    $name = $_POST['name'];
    $description = $_POST['description'];

    $db = new DbOperation();

    $result = $db->modifyUser($username, $password, $age, $name, $phon, $description);
    
    if($result == true){
        $response['error'] = false;
        $response['message'] = 'Did not modify';
    }
    else{
        $response['error'] = true;
        $response['message'] = 'Modification sucessful';
    }

} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

echo json_encode($response);

?>