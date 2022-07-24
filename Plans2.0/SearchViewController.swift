//
//  SearchViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 4/11/22.

import UIKit

class SearchViewController: UIViewController {
    
    private struct FriendStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let username2: String
        let name: String
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchField: UITableView!
    
    var invitations = ["John Smith, click to accept", "Demarcus Cousins, click to accept"];
    var filteredUsers = [User]();
    var usersInvited = User.allUsers
    var searchBarIsFull = false;
    var doubleClick : String = ""
    var numberOfInvites1 = 0;
    private let label: UILabel = {
        let label = UILabel();
        label.textColor = .systemRed;
        label.text = "Cannot Invite User Twice"
        return label;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self;
        searchField.dataSource = self;
        searchBar.delegate = self;
        searchBar.delegate = self;
        searchBar.searchTextField.textColor = .white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredUsers = usersInvited.filter({(user: User) -> Bool in
            return user.fullName.lowercased().contains(searchText.lowercased()) || user.userName.lowercased().contains(searchText.lowercased());
        });
        searchField.reloadData();
    }
    
    func isSearchBarEmpty() -> Bool {
        if(searchBar.text! != "") {
           // print("search bar full");
            return false;
        }
       // print("search bar empty");
        return true;
        //return searchBar.text?.isEmpty ?? true;
    }
    
    func isFiltering() -> Bool {
        if(!isSearchBarEmpty()) {
            label.removeFromSuperview()
        }
        return !isSearchBarEmpty();
    }
    
    func numberOfInvites(username1: String, username2 : String) -> Int {
        let db = DBManager();
        let url = (URL(string: "http://abdasalaam.com/Functions/loadInvitationsBetweenFriends.php?username1=\(username1)&username2=\(username2)"))!
        let messages = db.getRequest(url)
        //message will contain the username and the name of friends that have isAdded = 1 for the corresponing user
        return messages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */

}
extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {return filteredUsers.count};
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        let currentUser : User;
   
        currentUser = filteredUsers[indexPath.row];
        print("hi)");
        
        var cellConfig = cell.defaultContentConfiguration();
        if (filteredUsers[indexPath.row].fullName.count < 3) {
            cellConfig.text = filteredUsers[indexPath.row].userName;
        }
        else {
            cellConfig.text = filteredUsers[indexPath.row].fullName + ", " + filteredUsers[indexPath.row].userName;
        }
        cellConfig.textProperties.color = .white;
        cellConfig.secondaryText = "Swipe to send invitation";
        cellConfig.secondaryTextProperties.color = .white;
        cell.contentConfiguration = cellConfig;
        return cell;
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var parameters: [String: Any] = [:]
        if (true == true) {
            let share = UITableViewRowAction(style: .normal, title: "Invite") { action, index in
                let db = DBManager();
                let url = URL(string: "http://abdasalaam.com/Functions/addFriend.php")!
                if self.isFiltering() {
                    print(self.filteredUsers[indexPath.row])
                    parameters = [
                        "username1": User.currentUser.userName,
                        "username2": self.filteredUsers[indexPath.row].userName
                    ]
                }
                else {
                    print(self.usersInvited[indexPath.row])
                    parameters = [
                        "username1": User.currentUser.userName,
                        "username2": self.usersInvited[indexPath.row].userName
                    ]
                }
                let message = db.postRequest(url, parameters)
            }
            share.backgroundColor = UIColor.green
            if (self.numberOfInvites(username1:User.currentUser.userName,username2: self.filteredUsers[indexPath.row].userName) == 0) {
                return [share]
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchText: searchBar.text!);
        
    }
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar;
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex];
        filterContentForSearchText(searchText: searchBar.text!);
        searchField.reloadData();
    }
}
