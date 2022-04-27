//
//  PlanDetailViewController.swift
//  Plans2.0
//
//  Created by Muhammed Demirak on 4/16/22.
//

import UIKit

class PlanDetailViewController : UIViewController {
    @IBAction func unwindToPlanList(_ sender: UIStoryboardSegue) {}

    @IBOutlet weak var planTitle: UILabel!
    
    @IBOutlet weak var planAddress: UILabel!
    
    @IBOutlet weak var planDate: UILabel!
    
    @IBOutlet weak var planTime: UILabel!
    
    @IBOutlet weak var planDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planTitle.text = Plan.planDetailView.title;
        planAddress.text = Plan.planDetailView.address;
        planDate.text = Plan.dayText(Plan.planDetailView.day)
        planTime.text = Plan.timeText(Plan.planDetailView.startTime) + " - " + Plan.timeText(Plan.planDetailView.endTime)
        planDescription.text = Plan.planDetailView.notes
    }
    
    @objc func backTap() {
        //set values for signup to null;
    }
    
}
