//
//  WidgetModel.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/24.
//

import Foundation
import WidgetKit

struct AQIData: Codable {
    let aqi: String
    let status: String
    let siteName: String
    let pm25: String
    let pm10: String
    let o3: String
    let co: String
    let so2: String
    let no2: String
    
    static var empty: AQIData {
            return AQIData(aqi: "", status: "", siteName: "", pm25: "", pm10: "", o3: "", co: "", so2: "", no2: "")
    }
}

// 定義錯誤類型
enum WidgetError {
    case dataNotAvailable
    case networkError
    case unknown
    
    var message: String {
        switch self {
        case .dataNotAvailable: return "無資料"
        case .networkError: return "網路錯誤"
        case .unknown: return "未知錯誤"
        }
    }
}

// 修改 Entry 結構
struct AQIEntry: TimelineEntry {
    let date: Date
    let aqiData: AQIData?
    let error: WidgetError?
}


