//
//  AirQualityDataManager.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/14.
//

import Foundation
import WidgetKit // 要加這個

class AirQualityDataManager {
    static let shared = AirQualityDataManager()
    
    // 使用你設定的 App Group identifier
    private let defaults = UserDefaults(suiteName: "group.com.andyTest.AirQuality")
    
    func saveLatestAQIData(
        aqi: String,
        status: String,
        siteName: String,
        pm25: String,
        pm10: String,
        o3: String,
        co: String,
        so2: String,
        no2: String
    ) {
        let data = [
            "aqi": aqi,
            "status": status,
            "siteName": siteName,
            "pm25": pm25,
            "pm10": pm10,
            "o3": o3,
            "co": co,
            "so2": so2,
            "no2": no2
        ]
        
        // 儲存資料
        defaults?.set(data, forKey: "latestAQIData")
        defaults?.synchronize()
        // 嘗試強制 Widget 重新整理
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // 讀取資料前，確保初始化正確
    func getLatestAQIData() -> AQIData? {
        guard let data = defaults?.dictionary(forKey: "latestAQIData") as? [String: String] else {
            print("Error: Unable to retrieve AQI data from UserDefaults.")
            return nil
        }

        guard let aqi = data["aqi"],
              let status = data["status"],
              let siteName = data["siteName"],
              let pm25 = data["pm25"],
              let pm10 = data["pm10"],
              let o3 = data["o3"],
              let co = data["co"],
              let so2 = data["so2"],
              let no2 = data["no2"] else {
            print("Error: Missing required AQI data fields.")
            return nil
        }
        
        return AQIData(
            aqi: aqi,
            status: status,
            siteName: siteName,
            pm25: pm25,
            pm10: pm10,
            o3: o3,
            co: co,
            so2: so2,
            no2: no2
        )
    }
}
