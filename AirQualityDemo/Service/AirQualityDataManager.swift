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
        guard let userDefaults = UserDefaults(suiteName: "group.com.yourapp.airquality") else {
            print("無法初始化 UserDefaults，可能是 App Group 配置錯誤")
            return
        }
        userDefaults.set(aqi, forKey: "latestAQI")
        userDefaults.set(status, forKey: "latestStatus")
        userDefaults.set(siteName, forKey: "latestSiteName")
    }
}
