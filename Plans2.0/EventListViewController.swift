//
//  EventListViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 3/24/22.
//

import UIKit

class EventListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func unwindToList(_ sender: UIStoryboardSegue) {}
    
    static let detailSegueID = "PlanDetailSegue"
    // 11317 Bellflower Road, Cleveland, OH, 44106
    var filteredPlans = [Plan]();
    //var planList = Plan.samplePlanList
    //var plans = ["Pick Up Basketball by , Date: 4/14/2021. Time: 4:21. Address: 11 Tuttle Drive. User: ajp236", "Pick Up Soccer, Date: 4/14/2021. Time: 4:54. Address: 23 Pico Ave. User: ass112", "Birthday Party, Date: 4/14/2021. Time: 4:21. User: zach324", "Birthday Party, Date: 4/14/2021. Time: 10:56. User: joey243"];
    var searchBarIsFull = false;
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.detailSegueID,
            let dest = segue.destination as? PlanDetailViewController,
            let cell = sender as? UITableViewCell,
           let indexPath = self.tableView.indexPath(for: cell) {
            let rowIndex = indexPath.row
            guard let plan : Plan = getPlan(at: rowIndex) else {
                fatalError("couldn't get plan")
            }
            dest.configure(with: plan, editAction: { plan in
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        searchBar.delegate = self;
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self;
        //let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        //view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredPlans = User.currentUser.plans.filter({(plan: Plan) -> Bool in
            return plan.address.lowercased().contains(searchText.lowercased()) || plan.owner.fullName.lowercased().contains(searchText.lowercased()) || plan.owner.userName.lowercased().contains(searchText.lowercased()) || plan.title.lowercased().contains(searchText.lowercased()) || plan.date.lowercased().contains(searchText.lowercased());
        });
        tableView.reloadData();
    }
    
    func isSearchBarEmpty() -> Bool {
        if(searchBar.text! != "") {
            return false;
        }
        return true;
    }
    
    func isFiltering() -> Bool {
        return !isSearchBarEmpty();
    }
    
    func getPlan(at rowIndex: Int) -> Plan? {
        return filteredPlans[rowIndex]
    }
    
}
extension EventListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isFiltering()) {
            Plan.planDetailView = filteredPlans[indexPath.row];
        }
        Plan.planDetailView = User.currentUser.plans[indexPath.row];
    }
}

extension EventListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {return filteredPlans.count};
        return User.currentUser.plans.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        let currentPlan: Plan;
        if self.isFiltering() == true {
            currentPlan = filteredPlans[indexPath.row];
        }
        else {
            print(indexPath.row)
            currentPlan = User.currentUser.plans[indexPath.row];
        }
        var cellConfig = cell.defaultContentConfiguration();
        cellConfig.text = currentPlan.title + " by " + currentPlan.ownerUsername;
        cellConfig.textProperties.color = .white;
        cellConfig.secondaryText = "Date: " + Plan.dayText(currentPlan.day) + ", " + "Time: " + Plan.timeText(currentPlan.startTime) + ", " + "Address: " + currentPlan.address;
        cellConfig.secondaryTextProperties.color = .white;
        cell.contentConfiguration = cellConfig;
        return cell;
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if User.currentUser.plans[indexPath.row].ownerUsername == User.currentUser.userName {
            let share = UITableViewRowAction(style: .normal, title: "Mark as Done") { action, index in
                if self.isFiltering() == true {
                    print("Is Filtering");
                }
                else {
                    let db = DBManager();
                    let url = URL(string: "http://abdasalaam.com/Functions/deletePlan.php")!
                    let parameters: [String: Any] = [
                        "plan_id": User.currentUser.plans[indexPath.row].id,
                    ]
                    let message = db.postRequest(url, parameters)
                    print(message);
                    User.currentUser.plans.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            share.backgroundColor = UIColor.red
            return [share]
        }
        else {
            return nil
        }
    }
}
extension EventListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchText: searchBar.text!);
        
    }
}

extension EventListViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar;
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex];
        filterContentForSearchText(searchText: searchBar.text!);
        tableView.reloadData();
    }
}
