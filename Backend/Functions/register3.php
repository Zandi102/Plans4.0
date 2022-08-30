<?php


//importing required script
require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!verifyRequiredParams(array('username', 'password'))) {
        //getting values
        $username = $_POST['username'];
        $password = $_POST['password'];
        $phone = $_POST['phone'];

        //creating db operation object
        $db = new DbOperation();

        //adding user to database
        $result = $db->register3($username, $password, $phone);

        //making the response accordingly
        if ($result == true) {
            $response['error'] = false;
            $response['message'] = 'User created successfully';
         } else {
            $response['error'] = true;
            $response['message'] = 'User not created';
        }
    } else {
        $response['error'] = true;
        $response['message'] = 'Required parameters are missing';
    }
} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}

//function to validate the required parameter in request
function verifyRequiredParams($required_fields)
{

    //Getting the request parameters
    $request_params = $_REQUEST;

    //Looping through all the parameters
    foreach ($required_fields as $field) {
        //if any requred parameter is missing
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {

            //returning true;
            return true;
        }
    }
    return false;
}

echo json_encode($response);

?>