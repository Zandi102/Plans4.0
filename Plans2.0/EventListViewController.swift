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
        searchBar.searchTextField.textColor = .orange
    }
    
    
    
    func filterContentForSearchText(searchText: String) {
        filteredPlans = User.sampleUser.plans.filter({(plan: Plan) -> Bool in
            return plan.address.lowercased().contains(searchText.lowercased()) || plan.owner.fullName.lowercased().contains(searchText.lowercased()) || plan.owner.userName.lowercased().contains(searchText.lowercased()) || plan.title.lowercased().contains(searchText.lowercased()) || plan.date.lowercased().contains(searchText.lowercased());
        });
        tableView.reloadData();
    }
    
    func isSearchBarEmpty() -> Bool {
        if(searchBar.text! != "") {
            //print("search bar full");
            return false;
        }
        //print("search bar empty");
        return true;
        //return searchBar.text?.isEmpty ?? true;
    }
    
    func isFiltering() -> Bool {
        //searchField.reloadData();
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
        Plan.planDetailView = User.sampleUser.plans[indexPath.row];
    }
}

extension EventListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {return filteredPlans.count};
        return User.sampleUser.plans.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        let currentPlan: Plan;
        if isFiltering() {
            currentPlan = filteredPlans[indexPath.row];
        }
        else {
            currentPlan = User.sampleUser.plans[indexPath.row];
        }
        var cellConfig = cell.defaultContentConfiguration();
        cellConfig.text = currentPlan.title + " by " + currentPlan.ownerUsername;
        cellConfig.textProperties.color = .systemOrange;
        cellConfig.secondaryText = "Date: " + Plan.dayText(currentPlan.day) + ", " + "Time: " + Plan.timeText(currentPlan.startTime) + ", " + "Address: " + currentPlan.address;
        cellConfig.secondaryTextProperties.color = .systemOrange;
        cell.contentConfiguration = cellConfig;
        return cell;
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let share = UITableViewRowAction(style: .normal, title: "Mark as Done") { action, index in

                if self.isFiltering() == true {
                    print("Is Filtering");
                }
                else {
                    User.sampleUser.plans.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            share.backgroundColor = UIColor.red
            return [share]
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
