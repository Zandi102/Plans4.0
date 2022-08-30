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

    public var id : String
    public var title : String
    public var date : String
    public var day : Date
    public var startTime : Date
    public var endTime : Date
    public var startTime1 : String
    public var endTime1 : String
    public var address : String!
    public var notes : String
    public var ownerUsername: String
    private var planDateFormatter : DateFormatter = DateFormatter()
    public var validated = false;
    public var owner : User
    public var attendees : [User]! = []
    private var loc : CLLocation = CLLocation()
    public var _coord : CLLocationCoordinate2D? = nil
    public var isLive : Bool = false
    public var isComplete : Bool = false
    public static var planDetailView = Plan()

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
        self.id = ""
    }

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
        self.id = ""
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
        self.id = "";
    }
    
    //Constructor we use
    init(title : String, day: Date, startTime : Date, endTime : Date,
         address : String, notes : String, ownerUsername: String, plan_id: String) {
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
        self.id = plan_id
    }
    
    //Other constructor we use
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
        self.id = ""
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
        self.id = ""
    }

    

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
        formatter.setLocalizedDateFormatFromTemplate("MM dd, yyyy")
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
