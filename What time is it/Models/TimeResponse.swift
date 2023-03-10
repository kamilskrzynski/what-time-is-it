//
//  TimeResponse.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 03/01/2023.
//

import Foundation

/// Model created to get specific time from API
struct TimeResponse: Codable {
    
    let year: Int
    let month: Int
    let day: Int
    
    let hour: Int
    let minute: Int
    let seconds: Int
    
    let dateTime: String
    let time: String
    let timeZone: String
    let dayOfWeek: String
}
