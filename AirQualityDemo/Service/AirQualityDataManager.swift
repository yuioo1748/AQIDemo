//
//  AirQualityDataManager.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/14.
//

import Foundation

class AirQualityDataManager {
    static let shared = AirQualityDataManager()
    
    func saveLatestAQIData(aqi: String, status: String, siteName: String) {
        let userDefaults = UserDefaults(suiteName: "group.com.yourapp.airquality")
        userDefaults?.set(aqi, forKey: "latestAQI")
        userDefaults?.set(status, forKey: "latestStatus")
        userDefaults?.set(siteName, forKey: "latestSiteName")
        userDefaults?.synchronize()
    }
}
