//
//  Ex+Date.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/13.
//

import Foundation

extension Date {
    func convertToLocalDate() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.current
        
        return calendar.date(from: components) ?? self
    }
}
