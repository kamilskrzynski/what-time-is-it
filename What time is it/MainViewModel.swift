//
//  MainViewModel.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 04/01/2023.
//

enum TimeStyle {
    case time, date
}

import Foundation

final class MainViewModel: ObservableObject {
    
    public func getTime(for city: String, timeStyle: TimeStyle) -> Date {
        var time: Date = Date()
        APIHandler.shared.getTime(for: city) { timeViewModel in
            
            switch timeStyle {
            case .time:
                var timeComponents = DateComponents()
                timeComponents.hour = timeViewModel.hour
                timeComponents.minute = timeViewModel.minute
                timeComponents.second = timeViewModel.seconds
                
                time = Calendar.current.date(from: timeComponents) ?? Date()
            case .date:
                var dateComponents = DateComponents()
                dateComponents.day = timeViewModel.day
                dateComponents.month = timeViewModel.month
                dateComponents.year = timeViewModel.year
                
                time = Calendar.current.date(from: dateComponents) ?? Date()
            }
        }
        return time
    }
    
    public func getAbbrevation(from localization: String) -> String {
        let timezone = TimeZone.init(identifier: localization)?.abbreviation() ?? ""
        var timezoneAbbr: String = ""
        
        /// Greenwich Mean Time (GMT)
        if timezone.contains("GMT") && timezone.contains("+") {
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Greenwich Mean Time (\(timezoneComponents.first!)) +\(timezoneComponents.last!)")
        }
        else if timezone.contains("GMT") && timezone.contains("-") {
            let timezoneComponents = timezone.components(separatedBy: "-")
            timezoneAbbr = String("Greenwich Mean Time (\(timezoneComponents.first!)) -\(timezoneComponents.last!)")
        } else if timezone.contains("GMT"){
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Greenwich Mean Time (\(timezoneComponents.first!))")
        }
        /// Central European Time (CET)
        else if timezone.contains("CET") && timezone.contains("+") {
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Central European Time (\(timezoneComponents.first!)) +\(timezoneComponents.last!)")
        }
        else if timezone.contains("CET") && timezone.contains("-") {
            let timezoneComponents = timezone.components(separatedBy: "-")
            timezoneAbbr = String("Central European Time (\(timezoneComponents.first!)) -\(timezoneComponents.last!)")
        } else if timezone.contains("CET"){
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Central European Time (\(timezoneComponents.first!))")
        }
        
        /// Coordinated Universal Time (UTC)
        else if timezone.contains("UTC") && timezone.contains("+") {
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Coordinated Universal Time (\(timezoneComponents.first!)) +\(timezoneComponents.last!)")
        }
        else if timezone.contains("UTC") && timezone.contains("-") {
            let timezoneComponents = timezone.components(separatedBy: "-")
            timezoneAbbr = String("Coordinated Universal Time (\(timezoneComponents.first!)) =\(timezoneComponents.last!)")
        } else if timezone.contains("UTC"){
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Coordinated Universal Time (\(timezoneComponents.first!))")
        }
        
        /// Eastern Standard Time (EST)
        else if timezone.contains("EST") && timezone.contains("+") {
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Eastern Standard Time (\(timezoneComponents.first!)) +\(timezoneComponents.last!)")
        }
        else if timezone.contains("EST") && timezone.contains("-") {
            let timezoneComponents = timezone.components(separatedBy: "-")
            timezoneAbbr = String("Eastern Standard Time (\(timezoneComponents.first!)) -\(timezoneComponents.last!)")
        } else if timezone.contains("EST"){
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Eastern Standard Time (\(timezoneComponents.first!))")
        }
        
        return timezoneAbbr
    }
}
