//
//  DayOfTheYearResponse.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 06/01/2023.
//

import Foundation

/// Model created to get specific day of the year for given date from API
struct DayOfTheYearResponse: Codable {
    
    let day: Int
}
