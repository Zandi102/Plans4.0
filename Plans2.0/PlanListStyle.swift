//
//  PlanListStyle.swift
//  PlansMap
//
//  Created by Muhammed Demirak on 3/28/22.
//

import Foundation

enum PlanListStyle : Int {
    
    case all
    case your_plans
    case other_plans
    
    var name: String {
        switch self {
        case .all:
            return NSLocalizedString("All", comment: "All style title")
        case .your_plans:
            return NSLocalizedString("You", comment: "Your plans style title")
        case .other_plans:
            return NSLocalizedString("Others", comment: "Other plans style title")
        }
    }
    
    func shouldInclude(plan: Plan, user: User) -> Bool {
        let isOwner = plan.isPlanOwner(user: user)
        switch self {
        case .your_plans:
            return isOwner
        case .other_plans:
            return !isOwner
        case .all:
            return true
        }
        
    }
}
