//
//  Date+Plans.swift
//  PlansMap
//
//  Created by Muhammed Demirak on 3/25/22.
//

import Foundation

// date extension to parse the date easier
extension Date {
    
    // represents today/tomorrow date and time text
    var dayAndTimeText : String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    // represents just the time text
    var timeText : String {
        let text = formatted(date: .omitted, time: .shortened)
        let timeFormat = NSLocalizedString("%@", comment: "Time format string")
        return String(format: timeFormat, text)
    }
    
    // represents today and tomorrow day text
    var dayText : String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
