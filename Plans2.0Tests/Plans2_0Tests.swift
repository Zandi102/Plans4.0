//
//  Plans2_0Tests.swift
//  Plans2.0Tests
//
//  Created by Alex Pallozzi on 2/23/22.
//

import XCTest
@testable import Plans2_0

class Plans2_0Tests: XCTestCase {
    
    private struct FriendStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let username2: String
    }
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testUserLogin() throws {
        //creates a user. Tests the GET request related to creating a username.
        let user : User = User("AreenBean")!
        XCTAssertEqual(user.userName, "AreenBean")
        XCTAssertEqual(user.fullName, "Areen Nakhleh")
    }
    
    func testRegister() {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/register.php")!
        let parameters: [String: Any] = [
            "username":"AreenBean",
            "password":"iLoveTequila",
        ]
        //try to create the same user twice.
        let messageSuccess = db.postRequest(url, parameters)
        let messageFail = db.postRequest(url, parameters)
        XCTAssertEqual(messageSuccess, "User created successfully")
        XCTAssertEqual(messageFail, "User not created")
    }
    
    func testRemoveUser() {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/removeUser.php")!
        let parameters: [String: Any] = [
            "username":"AreenBean"
        ]
        //try to create the same user twice.
        let messageSuccess = db.postRequest(url, parameters)
        let messageFail = db.postRequest(url, parameters)
        XCTAssertEqual(messageSuccess, "User removed successfully")
    }
    
    func testModifyUser() {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/modifyUser.php")!
        let parametersS: [String: Any] = [
            "username":"AreenBean",
            "password":"iLoveTequila",
            "age":"0",
            "phone":"0",
            "name":"Areen Nakhleh",
            "description":"I really love tequila."
        ]
        let messageS = db.postRequest(url, parametersS)
        //php returns "Did not modify" when it did modify, just need to switch the response texts in php.
        XCTAssertEqual(messageS, "Did not modify")
    }
    
    func testAddFriend() {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/addFriend.php")!
        let succParams = [
            "username1": "AreenBean",
            "username2": "momo"
        ]
        //fake username for testing
        let failParams = [
            "username1": "AreenBean",
            "username2": "FakeUsername"
        ]
        
        let messageS = db.postRequest(url, succParams)
        let messageF = db.postRequest(url, failParams)
        XCTAssertEqual(messageS, "User is now added and pending for approval")
        XCTAssertEqual(messageF, "Failed to add user")
    }
    
    func testApproveFriend() {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/approveFriend.php")!
        let parameters: [String: Any] = [
            "username1":"AreenBean",
            "username2":"momo"
        ]
        let message = db.postRequest(url, parameters)
        XCTAssertEqual(message, "Request is now approved")
    }
    
    func testGetRequest() {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadFriends.php?username=AreenBean")!
        let messages = db.getRequest(url)
        if messages.count > 0 {
            let jsonData = messages[0].data(using: .utf8)!
            let resp: FriendStruct = try! JSONDecoder().decode(FriendStruct.self, from: jsonData);
            XCTAssertEqual(resp.username2, "momo")
        }
        else {
            XCTAssertFalse(true)
        }
    }
    
    func testHash() {
        
    }

}
