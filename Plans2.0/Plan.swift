//
//  Plan.swift
//  PlansMap
//
//  Created by Muhammed Demirak on 3/9/22.
//

//

//  Plan.swift

//  PlansMap

//

//  Created by Muhammed Demirak on 3/9/22.

//

import UIKit
import Foundation
import CoreLocation



class Plan : Equatable, Identifiable {

    

    // Initialization Fields

    public var id : String = UUID().uuidString  // the uniquely generated id of the plan
    public var title : String                    // title of the plan created by the owner
    public var date : String                       // the day of the plan
    public var day : Date
    public var startTime : Date                 // the starting time of the plan
    public var endTime : Date                   // the ending time of the plan
    public var startTime1 : String                 // the starting time of the plan
    public var endTime1 : String                  // the ending time of the plan
    public var address : String!                // the address the plan will be located at
    public var notes : String
    public var ownerUsername: String// the details of the plan

    //public var image : UIImage? = nil           // the image of the plan (that may work)

    private var planDateFormatter : DateFormatter = DateFormatter() // a date formatter that may be needed
    public var validated = false;


    public var owner : User
    public var attendees : [User]! = []       // the users who are attending the plan
    private var loc : CLLocation = CLLocation() // the core location property of the address
    public var _coord : CLLocationCoordinate2D? = nil
    public var isLive : Bool = false            // checks if the plan is live and active (if the start
    public var isComplete : Bool = false        // checks if the plan is completed (if the end time
    public static var planDetailView = Plan();

    init() {
        self.title = ""
        self.startTime = Date()
        self.day = Date()
        self.endTime = Date()
        self.address = ""
        self.notes =  ""
        self.owner = User()
        self.date = ""
        self.endTime1 = ""
        self.startTime1 = ""
        self.ownerUsername = owner.userName
    }
    
    //Find plan based on plan ID
    /*init(planID : String) {
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/loadPlan.php?plan_id=\(planID)")!
        let message = db.getRequest(url)
        print(message)
        let jsonData = message.data(using: .utf8)!
        let resp: PlanStruct = try! JSONDecoder().decode(PlanStruct.self, from: jsonData)
        self.title = resp.plan_name
        self.startTime = Date()
        self.day = Date()
        self.endTime = Date()
        self.latitude = resp.latitude
        self.longitude = resp.longitude
        self.notes =  ""
        self.date = ""
        self.endTime1 = ""
        self.startTime1 = ""
        self.startTime = textToTime(resp.startTime)
        self.day = textToDate(resp.date)
        self.endTime = textToTime(resp.endTime)
    }*/

    init(title : String, startTime : Date, endTime : Date,
         address : String, notes : String) {
        self.title = title
        self.startTime = startTime
        self.day = startTime
        self.endTime = endTime
        self.address = address
        self.notes =  notes
        self.owner = User()
        self.date = ""
        self.endTime1 = ""
        self.startTime1 = ""
        self.ownerUsername = owner.userName
    }
    
    
    init(title : String, startTime : Date, endTime : Date,
         address : String, notes : String, owner: User) {
        self.title = title
        self.startTime = startTime
        self.day = startTime
        self.endTime = endTime
        self.address = address
        self.notes =  notes
        self.owner = owner
        self.date = ""
        self.endTime1 = ""
        self.startTime1 = ""
        self.ownerUsername = owner.userName
    }
    
    init(title : String, day: Date, startTime : Date, endTime : Date,
         address : String, notes : String, ownerUsername: String) {
        self.title = title
        self.startTime = startTime
        self.day = day
        self.endTime = endTime
        self.address = address
        self.notes =  notes
        self.ownerUsername = ownerUsername
        self.date = ""
        self.endTime1 = ""
        self.startTime1 = ""
        self.owner = User()
    }
    

    // initializer 3, input dates as Strings, for the DBManager?

    init(title : String, date : String, startTime1 : String, endTime1: String, address : String, notes : String, owner : User) {
        self.title = title
        self.startTime1 = startTime1
        self.date = date
        self.endTime1 = endTime1
        self.address = address
        self.notes =  notes
        self.owner = owner
        self.startTime = Date()
        self.day = Date()
        self.endTime = Date()
        self.ownerUsername = owner.userName

    }

    

    // sample plans

    private static var plan1 = Plan(title: "Pickup Basketball", date: "4/14/2021", startTime1: "7:50", endTime1: "", address: "11 Tuttle Drive", notes: "Cool game", owner: User.sampleFriendList[0])

    private static var plan2 = Plan(title: "Pickup Soccer", date: "4/15/2021", startTime1: "2:35", endTime1: "", address: "15 Tuttle Drive", notes: "Soccer game in my backyard, bring friends!", owner: User.sampleFriendList[1])

    private static var plan3 = Plan(title: "Birthday Party", date: "6/15/2021", startTime1: "6:00", endTime1: "", address: "23 Pico Ave", notes: "BYOB", owner: User.sampleFriendList[2])

    private static var plan4 = Plan(title: "Graduation Party", date: "5/04/2021", startTime1: "7:00", endTime1: "", address: "21 Wysteria Lane", notes: "Celebrate our sons graduation!", owner: User.sampleFriendList[3])

    // a sample plan list

    public static var samplePlanList = [plan1, plan2, plan3, plan4];

    

    // checks if the inputted user is the plan owner

    func isPlanOwner(user: User) -> Bool {
        return user == self.owner
    }

    

    // assigns the owner

    func setOwner(newOwner : User) {
        self.owner = newOwner
    }

    

    // gets the day text

    static func dayText(_ date : Date) -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.setLocalizedDateFormatFromTemplate("MMM dd, yyyy")
        return formatter.string(from: date)

    }


    // gets the time text

    static func timeText(_ date: Date) -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeStyle = .medium
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    static func textToTime(_ string: String) -> Date {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: string)!
       
    }
    static func textToDate(_ string: String) -> Date {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)!
       // return date!
    }
    
    

    // .equals override in swift

    static func == (lhs: Plan, rhs: Plan) -> Bool {
        if (lhs.id == rhs.id) {
            return true
        }
        else {
            return false
        }
    }
}



// array of plans

extension Array where Element == Plan {
    func indexOfPlan(with id: Plan.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}
