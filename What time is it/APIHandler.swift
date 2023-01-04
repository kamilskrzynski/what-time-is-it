//
//  APIHandler.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 03/01/2023.
//


import Foundation
import Combine

final class APIHandler {
    
    static let shared = APIHandler()
    
    func getTime(for timezone: String, completionHandler: @escaping (TimeViewModel) -> Void) {
        guard let url = URL(string: "https://www.timeapi.io/api/Time/current/zone?timeZone=\(timezone)") else {
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
               let timeViewModel = try? JSONDecoder().decode(TimeViewModel.self, from: data) {
                completionHandler(timeViewModel)
            }
        }
        task.resume()
    }
}
