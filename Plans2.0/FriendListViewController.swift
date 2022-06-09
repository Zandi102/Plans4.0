//
//  FriendListViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 4/11/22.
//
import UIKit

class FriendListViewController: UIViewController {
    
    private struct UserStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let username: String
        let phone: String
        let age: String
        let password: String
        let name: String
        let description: String
    }
    
    @IBOutlet weak var friendTable: UITableView!
    
    var friends = User.currentUser.friends
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTable.delegate = self;
        friendTable.dataSource = self;
    }
    
    @IBAction func unwindToFriendList(_ sender: UIStoryboardSegue) {}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often wxant to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FriendListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(friends[indexPath.row]);
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadUser.php?username=\(friends[indexPath.row].userName)")!
        let messages = db.getRequest(url)
        if messages.count > 0 {
            let userFields = messages[0]
            print("In User Class")
            print(userFields)
            let jsonData = userFields.data(using: .utf8)!
            let resp: UserStruct = try! JSONDecoder().decode(UserStruct.self, from: jsonData);
            User.friendToShow.fullName = resp.name
            User.friendToShow.userName = resp.username
            User.friendToShow.description = resp.description
        }
    }
}
extension FriendListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        var cellConfig = cell.defaultContentConfiguration();
        if (friends[indexPath.row].fullName.count < 3) {
            cellConfig.text = friends[indexPath.row].userName;
        }
        else {
            cellConfig.text = friends[indexPath.row].fullName;
            cellConfig.secondaryText = friends[indexPath.row].userName;
        }
        cellConfig.textProperties.color = .systemOrange;
        cellConfig.secondaryTextProperties.color = .systemOrange;
        cell.contentConfiguration = cellConfig;
        return cell;
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var parameters1: [String: Any] = [:]
        let share = UITableViewRowAction(style: .normal, title: "Delete Friend") { action, index in
            let db = DBManager();
            let url = URL(string: "http://abdasalaam.com/Functions/deleteFriend.php")!
            print(self.friends[indexPath.row])
            parameters1 = [
                "username1": User.currentUser.userName,
                "username2": self.friends[indexPath.row].userName
            ]
            let message = db.postRequest(url, parameters1)
            self.friends.remove(at: indexPath.row)
            tableView.reloadData()
        }
        share.backgroundColor = UIColor.red
        return [share]
    }
}
