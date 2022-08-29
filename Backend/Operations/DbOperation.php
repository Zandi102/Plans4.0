<?php


class DbOperation
{
    private $conn;
    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Constants.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    //Function to create a new user 
    public function register($username, $password)
    {
        try{
            $stmt = $this->conn->query("INSERT INTO User (username, password) VALUES ('$username', '$password')");
            $result = $stmt;
        }
        catch (mysqli_sql_exception $e){ 
            $result = false;
        }
        return $result; 
    }

    public function register3($username, $password, $phone)
    {
        try{
            $stmt = $this->conn->query("INSERT INTO User (username, password, phone) VALUES ('$username', '$password', '$phone')");
            $result = $stmt;
        }
        catch (mysqli_sql_exception $e){ 
            $result = false;
        }
        return $result; 
    }

    public function createCompany($compName)
    {
        try{
            $stmt = $this->conn->query("INSERT INTO Company (compName) VALUES ('$compName')");
            $result = $stmt;
        }
        catch (mysqli_sql_exception $e){ 
            $result = false;
        }
        return $result; 
    }

    public function addSponsor($compID, $plan_id, $amount)
    {
        try{
            $stmt = $this->conn->query("INSERT INTO Sponsors (amount, compID, plan_id) VALUES ('$amount', '$compID', '$plan_id')");
            $result = $stmt;
        }
        catch (mysqli_sql_exception $e){ 
            echo json_encode($e);
            $result = false;
        }
        return $result; 
    }

    public function register2($username, $password, $name, $phone, $age, $description)
    {
        try{
            $stmt = $this->conn->query("INSERT INTO User (username, password, name, phone, age, description) VALUES ('$username', '$password', '$name', '$phone', '$age', '$description')");
            $result = $stmt;
        }
        catch (mysqli_sql_exception $e){ 
            $result = false;
        }
        return $result; 
    }

    public function login($username, $password)
    {
        $resultarray = [];
        $loggedin = false;
        try{
            $stmt = $this->conn->query("SELECT username FROM User WHERE username = '$username' AND password = '$password'");
            $result = $stmt;
            $row=mysqli_fetch_assoc($stmt);
            if ($row != null) {
                $loggedin = true;
            }
        }
        catch(mysqli_sql_exception $e){}
        return $loggedin;
    }

    // removes a user from database
    public function removeUser($username)
    {
        $result;
        try{
            $stmt = $this->conn->query("DELETE FROM User WHERE username = '$username'");
            $result = $stmt;
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    // modifies all user's information
    public function modifyUser($username, $password, $age, $name, $phone, $description)
    {
        $result;
        try{
        $stmt = $this->conn->query("UPDATE User SET password = '$password', age = '$age', name = '$name', phone = '$phone', description = '$description' WHERE username = '$username'");
        $result = $stmt;
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }
    
    public function getPlanOnDate($username, $date)
    {
        $stmt = $this->conn->query("SELECT p.plan_id FROM Plan p, User u WHERE p.username = u.username AND u.username = '$username' AND p.date = '$date'");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }
    // creates a new plan 
    public function createPlan($username, $description, $plan_name, $startTime, $endTime, $date, $address)
    {
        $result;
        try{
            $stmt = $this->conn->query("INSERT INTO Plan (username, description, plan_name, startTime, endTime, date, address) 
            VALUES ('$username', '$description', '$plan_name', '$startTime', '$endTime', '$date', '$address')");
            $result = $stmt;   
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    public function getPlanID($plan_name, $address, $username)
    {
        $resultarray = array();
        try{
            $stmt = $this->conn->query("SELECT P.plan_id FROM Plan as P WHERE P.plan_name = '$plan_name' AND P.address = '$address' AND P.username = '$username'");
            while($row=mysqli_fetch_assoc($stmt)) {
                $resultarray[] = $row;
            }
        }
        catch(mysqli_sql_exception $e){}
        return $resultarray;
    }
    // loads all user plans 
    public function loadUserPlans($username)
    {
        $resultarray = array();
        try{
            $stmt = $this->conn->query("SELECT * FROM Plan WHERE username = '$username'");
            while($row=mysqli_fetch_assoc($stmt)) {
                $resultarray[] = $row;
            }
        }
        catch(mysqli_sql_exception $e){}
        return $resultarray;
    }
    
    /// loads all friends' plans
    public function loadFriendPlans($username)
    {
        $stmt = $this->conn->query("SELECT DISTINCT P.* FROM Plan P, hasFriend H WHERE H.username1 = '$username' AND H.username2 = P.username AND H.isAdded = 1");
        $resultarray = array();
		while($row=mysqli_fetch_assoc($stmt)) {
			$resultarray[] = $row;
		}
        return $resultarray;
    }

    public function deletePlan($plan_id)
    {
        $result;
        try{
            $stmt = $this->conn->query("DELETE FROM Plan WHERE plan_id = $plan_id");
            $result = $this->conn->affected_rows > 0;

        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    public function modifyPlan($plan_id, $plan_name, $endTime, $startTime, $date, $description, $longitude, $latitude)
    {
        try{
        $stmt = $this->conn->query("UPDATE Plan SET plan_name = '$plan_name', endTime = '$endTime', startTime = '$startTime', date = '$date', description = '$description', longitude = $longitude, latitude = $latitude WHERE plan_id = $plan_id");
        $result = $this->conn->affected_rows > 0;
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    // loads a user and their information 
    public function loadUser($username)
    {
        $stmt = $this->conn->query("SELECT * FROM User WHERE username = '$username'");
        $resultarray = array();
		while($row=mysqli_fetch_assoc($stmt)) {
			$resultarray[] = $row;
		}
        return $resultarray;
    }

    // loads all friends of a user
    public function loadFriends($username)
    {
        $stmt = $this->conn->query("SELECT H.username2, U.name FROM hasFriend as H, User as U WHERE H.username1 = '$username' AND H.isAdded = 1 AND U.username = H.username2");
        $resultarray = array();
		while($row=mysqli_fetch_assoc($stmt)) {
			$resultarray[] = $row;
		}
        return $resultarray;
    }

    // loads friends whos's friend request is still pending
    public function loadPendingFriends($username)
    {
        $stmt = $this->conn->query("SELECT H.username2, U.name FROM hasFriend as H, User as U WHERE H.username1 = '$username' AND H.isAdded = 0 AND U.username = H.username2");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }

    public function loadPossibleFriends($username)
    {
        $stmt = $this->conn->query("SELECT H.username2, U.name FROM hasFriend as H, User as U WHERE H.username1 = '$username' AND U.username = H.username2");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }

    public function loadInvitationsBetweenFriends($username1, $username2)
    {
        $stmt = $this->conn->query("SELECT H.username2 FROM hasFriend as H WHERE H.username1 = '$username1' AND H.username2 = '$username2' ");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }

    public function deleteFriend($username1, $username2)
    {
        try{
            $stmt = $this->conn->query("DELETE FROM hasFriend WHERE (username1 = '$username1' AND username2 = '$username2') OR  (username1 = '$username2' AND username2 = '$username1')");
            $result = $this->conn->affected_rows > 0;
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    // load one individual plan
    public function loadPlan($plan_id)
    {
        $stmt = $this->conn->query("SELECT * FROM Plan WHERE plan_id = $plan_id");
        $resultarray = array();
		while($row=mysqli_fetch_assoc($stmt)) {
			$resultarray[] = $row;
		}
        return $resultarray;
    }

    // add a friend 
    public function addFriend($username1, $username2)
    {
        try{
            $stmt = $this->conn->query("INSERT INTO hasFriend (username1, username2, isAdded) VALUES ('$username1','$username2',0)");
            $stmt2 = $this->conn->query("INSERT INTO hasFriend (username1, username2, isAdded) VALUES ('$username2','$username1',0)");
            $result = $stmt && $stmt2;
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    // approave a friend who's request is still pending by setting is Added = 1
    public function approveFriend($username1, $username2)
    {
        try{
            $stmt = $this->conn->query("UPDATE hasFriend SET isAdded = 1 WHERE (username1 = '$username1' AND username2 = '$username2') OR (username1 = '$username2' AND username2 = '$username1')");
            $result = $stmt;
        }
        catch(mysqli_sql_exception $e)
        {
            $result = false;
        }
        return $result;
    }

    public function loadUsers()
    {
        $stmt = $this->conn->query("SELECT username, name FROM User");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }

    public function loadAllPlans()
    {
        $stmt = $this->conn->query("SELECT * FROM Plan");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }

    public function loadAllCompanies()
    {
        $stmt = $this->conn->query("SELECT * FROM Company");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }

    public function loadSponsorersOnDate($date)
    {
        $stmt = $this->conn->query("SELECT DISTINCT C.compID, C.compName FROM Company as C, Sponsors as S, Plan as P WHERE C.compID = S.compID AND P.plan_id = S.plan_id AND P.date = '$date'");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }
    
    public function getAmountSponsored($compName, $date)
    {
        $stmt = $this->conn->query("SELECT S.amount FROM Company as C, Sponsors as S, Plan as P WHERE C.compID = S.compID AND P.plan_id = S.plan_id AND C.compName = '$compName' AND P.date = '$date'");
        $resultarray = array();
        while($row=mysqli_fetch_assoc($stmt)) {
            $resultarray[] = $row;
        }
        return $resultarray;
    }
}
?>

