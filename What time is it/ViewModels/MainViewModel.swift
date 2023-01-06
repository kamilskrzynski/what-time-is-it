//
//  MainViewModel.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 04/01/2023.
//

import Foundation

final class MainViewModel: ObservableObject {
    
    @Published var time: Date = Date()
    @Published var date: Date = Date()
    @Published var citiesDict = [String: Date]()
    
    let localizationsArray = TimeZone.knownTimeZoneIdentifiers
    let cities = ["Los Angeles", "New York", "London", "Paris", "Kiev", "Tokyo"]
    
    public func getTime(for city: String) {
        APIHandler.shared.getTime(for: city) { timeViewModel in
            var timeComponents = DateComponents()
            timeComponents.hour = timeViewModel.hour
            timeComponents.minute = timeViewModel.minute
            timeComponents.second = timeViewModel.seconds
            
            DispatchQueue.main.async {
                self.time = Calendar.current.date(from: timeComponents)!
            }
        }
    }
    
    public func getDate(for city: String) {
        APIHandler.shared.getTime(for: city) { timeViewModel in
            var dateComponents = DateComponents()
            dateComponents.day = timeViewModel.day
            dateComponents.month = timeViewModel.month
            dateComponents.year = timeViewModel.year
            
            DispatchQueue.main.async {
                self.date = Calendar.current.date(from: dateComponents)!
            }
        }
    }
    
    func getLocalTimes() {
        for city in cities {
            let changedCity = city.replacingOccurrences(of: " ", with: "_")
            APIHandler.shared.getTime(for: localizationsArray.first(where: { $0.contains(changedCity)}) ?? "") { timeViewModel in
                var timeComponents = DateComponents()
                timeComponents.hour = timeViewModel.hour
                timeComponents.minute = timeViewModel.minute
            
                DispatchQueue.main.async {
                    self.citiesDict.updateValue(Calendar.current.date(from: timeComponents)!, forKey: city)
                    
                }
            }
        }
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
