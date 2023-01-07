//
//  MainViewModel.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 04/01/2023.
//

import Foundation

final class MainViewModel: ObservableObject {
    
    
    /// Variables
    @Published var time: Date = Date()
    @Published var date: Date = Date()
    @Published var dayOfTheYear: Int = 0
    @Published var citiesDict = [String: Date]()
    
    @Published var isSearchToggle = false
    @Published var searchText = ""
    @Published var localization = TimeZone.current.identifier
    @Published var localizationName = ""
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let shortTimeFormatter = DateFormatter()
    let localizationsArray = TimeZone.knownTimeZoneIdentifiers
    let cities = ["Los Angeles", "New York", "London", "Paris", "Kiev", "Tokyo"]
    
    
    /// Getting time from API for given city
    /// - Parameter city: City name
    public func getTime(for city: String) {
        APIHandler.shared.getTime(for: city) { timeResponse in
            var timeComponents = DateComponents()
            timeComponents.hour = timeResponse.hour
            timeComponents.minute = timeResponse.minute
            timeComponents.second = timeResponse.seconds
            
            DispatchQueue.main.async {
                self.time = Calendar.current.date(from: timeComponents)!
            }
        }
        
    }
    
    /// Getting date from API for given city
    /// - Parameter city: City name
    public func getDate(for city: String) {
        APIHandler.shared.getTime(for: city) { timeResponse in
            var dateComponents = DateComponents()
            dateComponents.day = timeResponse.day
            dateComponents.month = timeResponse.month
            dateComponents.year = timeResponse.year
            
            APIHandler.shared.getDayOfTheYear(year: timeResponse.year, month: timeResponse.month, day: timeResponse.day) { dayOfTheYearResponse in
                DispatchQueue.main.async {
                    self.dayOfTheYear = dayOfTheYearResponse.day
                }
            }
            
            DispatchQueue.main.async {
                self.date = Calendar.current.date(from: dateComponents)!
            }
        }
    }
    
    
    /// Checks what day it is and returns adjective version of number
    /// - Returns: adjective version of number
    func checkDayOfTheYear() -> String {
        switch dayOfTheYear {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        default:
            return "th"
        }
    }
    
    
    /// Getting local time for given array of cities
    func getLocalTimes() {
        for city in cities {
            let changedCity = city.replacingOccurrences(of: " ", with: "_")
            APIHandler.shared.getTime(for: localizationsArray.first(where: { $0.contains(changedCity)}) ?? "") { timeResponse in
                var timeComponents = DateComponents()
                timeComponents.hour = timeResponse.hour
                timeComponents.minute = timeResponse.minute
                
                DispatchQueue.main.async {
                    self.citiesDict.updateValue(Calendar.current.date(from: timeComponents)!, forKey: city)
                    
                }
            }
        }
    }
    
    
    /// Getting abbrevation name for given localization
    /// - Parameter localization: given localization
    /// - Returns: Timezone name
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
        
        /// Eastern European Time (EET)
        else if timezone.contains("EET") && timezone.contains("+") {
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Eastern European Time (\(timezoneComponents.first!)) +\(timezoneComponents.last!)")
        }
        else if timezone.contains("EET") && timezone.contains("-") {
            let timezoneComponents = timezone.components(separatedBy: "-")
            timezoneAbbr = String("Eastern European Time (\(timezoneComponents.first!)) -\(timezoneComponents.last!)")
        } else if timezone.contains("EET"){
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Eastern European Time (\(timezoneComponents.first!))")
        }
        
        /// Western European Time (WET)
        else if timezone.contains("WET") && timezone.contains("+") {
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Western European Time (\(timezoneComponents.first!)) +\(timezoneComponents.last!)")
        }
        else if timezone.contains("WET") && timezone.contains("-") {
            let timezoneComponents = timezone.components(separatedBy: "-")
            timezoneAbbr = String("Western European Time (\(timezoneComponents.first!)) -\(timezoneComponents.last!)")
        } else if timezone.contains("WET"){
            let timezoneComponents = timezone.components(separatedBy: "+")
            timezoneAbbr = String("Western European Time (\(timezoneComponents.first!))")
        }
        
        return timezoneAbbr
    }
    
    /// Setting up specific DateFormatters
    func setupFormatters() {
        // timeFormatter
        timeFormatter.dateFormat = "HH:mm:ss"
        
        // dateFormatter
        dateFormatter.locale = Locale(identifier: "en_us")
        dateFormatter.dateFormat = "EEEE, MMMM d YYYY"
        
        // shortTimeFormatter
        shortTimeFormatter.dateFormat = "HH:mm"
    }
    
    
    /// Getting City name from localization timezone
    func getLocalizationName() {
        let localizationArray = localization.components(separatedBy: "/")
        localizationName = localizationArray.last!.replacingOccurrences(of: "_", with: " ")
    }
}
