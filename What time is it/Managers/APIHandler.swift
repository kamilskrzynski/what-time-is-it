//
//  APIHandler.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 03/01/2023.
//


import Foundation
import Combine

enum Endpoint: String {
    case time = "Time/current/zone?timeZone="
    case conversion = "Conversion/DayOfTheYear/"
}

final class APIHandler {
    
    static let shared = APIHandler()
    static let basicUrl = "https://www.timeapi.io/api/"
    
    func getTime(for timezone: String, completionHandler: @escaping (TimeResponse) -> Void) {
        guard let url = URL(string: "\(APIHandler.basicUrl)\(Endpoint.time)\(timezone)") else {
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
               let timeViewModel = try? JSONDecoder().decode(TimeResponse.self, from: data) {
                completionHandler(timeViewModel)
            }
        }
        task.resume()
    }
    
    func getDayOfTheYear(year: String, month: String, day: String, completionHandler: @escaping (DayOfTheYearResponse) -> Void) {
        guard let url = URL(string: "\(APIHandler.basicUrl)\(Endpoint.conversion)\(year)-\(month)-\(day)") else {
            fatalError("Wrong URL")
        }
    }
}
