//
//  InviteViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 4/10/22.
//

import UIKit

class InviteViewController: UIViewController{
    
    /*private let table: UITableView = {
        let table = UITableView();
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        return table;
    }()*/
    
    @IBOutlet var tableView: UITableView!;
    var doubleClick : String = ""
    var usersInv = User.sampleUser.invites
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self;
        tableView.dataSource = self;
        //tableView.backgroundColor = .systemGray2
        //title = "Invite List";
        //view.addSubview(table);
       // table.dataSource = self;
    }
}
extension InviteViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if doubleClick != usersInv[indexPath.row].userName {
            doubleClick = usersInv[indexPath.row].userName
            let db = DBManager();
            let url = URL(string: "http://abdasalaam.com/Functions/approveFriend.php")!
            let parameters: [String: Any] = [
                "username1":User.sampleUser.userName,
                "username2":usersInv[indexPath.row].userName
            ]
            let message = db.postRequest(url, parameters)
            if (message == "Request is now approved") {
                User.sampleUser.addFriend(user: usersInv[indexPath.row])
                User.sampleUser.removeInvite(username: usersInv[indexPath.row].userName)
                usersInv.remove(at: indexPath.row)
                //User.sampleUser.invites.removeAll(where: User.username == usersInv[indexPath.row].userName)
                
                tableView.reloadData();
            }
        //print(invitations[indexPath.row]);
        }
    }
}

extension InviteViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersInv.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        var cellConfig = cell.defaultContentConfiguration();
        if (usersInv[indexPath.row].fullName.count < 3) {
            cellConfig.text = usersInv[indexPath.row].userName;
            cellConfig.secondaryText = "Double Click to Add!";
        }
        else {
            cellConfig.text = usersInv[indexPath.row].fullName + ", " + usersInv[indexPath.row].userName;
            cellConfig.secondaryText = "Double Click to Add!";
        }
        cellConfig.secondaryText = "Double Click to Add!";
        cellConfig.secondaryTextProperties.color = .systemOrange;
        cellConfig.textProperties.color = .systemOrange;
        cell.contentConfiguration = cellConfig;
        return cell;
    }
}
