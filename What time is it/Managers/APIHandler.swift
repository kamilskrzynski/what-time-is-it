//
//  APIHandler.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 03/01/2023.
//


import Foundation

final class APIHandler {
    
    // Constant values
    static let shared = APIHandler()
    static let basicUrl = "https://www.timeapi.io/api/"
    let timeEndpoint = "Time/current/zone?timeZone="
    let conversionEndpoint = "Conversion/DayOfTheYear/"
    
    
    /// Getting time from API
    /// - Parameters:
    ///   - timezone: timezone, e.g. Europe/Warsaw
    ///   - completionHandler: espacing closure returning TimeResponse model
    func getTime(for timezone: String, completionHandler: @escaping (TimeResponse) -> Void) {
        guard let url = URL(string: "\(APIHandler.basicUrl)\(timeEndpoint)\(timezone)") else {
            fatalError("Wrong URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error with fetching time: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let timeResponse = try? JSONDecoder().decode(TimeResponse.self, from: data) {
                completionHandler(timeResponse)
            }
        }
        task.resume()
    }
    
    /// Getting day of the year from API
    /// - Parameters:
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - completionHandler: escaping closure returning DayOfTheYearResponse model
    func getDayOfTheYear(year: Int, month: Int, day: Int, completionHandler: @escaping (DayOfTheYearResponse) -> Void) {
        
        // Checking if month/day number is less than 10 to add 0 before month/day value
        // To make sure we use valid URL before using API
        var validMonth: String {
            if month < 10 {
                return "0\(month)"
            } else {
                return String(describing: month)
            }
        }
       
        var validDay: String {
            if day < 10 {
                return "0\(day)"
            } else {
                return String(describing: day)
            }
        }
        
        // Checking if URL is valid
        guard let url = URL(string: "\(APIHandler.basicUrl)\(conversionEndpoint)\(year)-\(validMonth)-\(validDay)") else {
            fatalError("Wrong URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error with fetching day of the year: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let dayOfTheYearResponse = try? JSONDecoder().decode(DayOfTheYearResponse.self, from: data) {
                completionHandler(dayOfTheYearResponse)
            }
        }
        task.resume()
    }
}
