//
//  JSONModel.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/2.
//

import Foundation
import CoreLocation

// MARK: - 空氣品質資料模型 （非當日
struct APIResponse: Codable {
    let fields: [Field]
    let resourceId: String
    let extras: Extras
    let includeTotal: Bool
    let total: String
    let resourceFormat: String
    let limit: String
    let offset: String
    let links: Links
    let records: [Record]
    
    enum CodingKeys: String, CodingKey {
        case fields
        case resourceId = "resource_id"
        case extras = "__extras"
        case includeTotal = "include_total"
        case total
        case resourceFormat = "resource_format"
        case limit
        case offset
        case links = "_links"
        case records
    }
}

/// MARK: - 空氣品質資料記錄
struct Record: Codable {
    let siteId: String
    let siteName: String
    let monitorDate: String //時間欄位
    let aqi: String
    let so2SubIndex: String
    let coSubIndex: String
    let o3SubIndex: String
    let pm10SubIndex: String
    let no2SubIndex: String
    let o38SubIndex: String
    let pm25SubIndex: String
    
    enum CodingKeys: String, CodingKey {
        case siteId = "siteid"
        case siteName = "sitename"
        case monitorDate = "monitordate"
        case aqi
        case so2SubIndex = "so2subindex"
        case coSubIndex = "cosubindex"
        case o3SubIndex = "o3subindex"
        case pm10SubIndex = "pm10subindex"
        case no2SubIndex = "no2subindex"
        case o38SubIndex = "o38subindex"
        case pm25SubIndex = "pm25subindex"
    }
}

// MARK: - 監測站基本資料模型
struct StationResponse: Codable {
    let fields: [Field]
    let resourceId: String
    let extras: Extras
    let includeTotal: Bool
    let total: String
    let resourceFormat: String
    let limit: String
    let offset: String
    let links: Links
    let records: [StationRecord]
    
    enum CodingKeys: String, CodingKey {
        case fields
        case resourceId = "resource_id"
        case extras = "__extras"
        case includeTotal = "include_total"
        case total
        case resourceFormat = "resource_format"
        case limit
        case offset
        case links = "_links"
        case records
    }
}

/// MARK: - 監測站基本資料記錄
struct StationRecord: Codable {
    let siteName: String
    let siteEngName: String
    let areaName: String
    let county: String
    let township: String
    let siteAddress: String
    let longitude: String  // TWD97經度
    let latitude: String   // TWD97緯度
    let siteType: String
    let siteId: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "sitename"
        case siteEngName = "siteengname"
        case areaName = "areaname"
        case county
        case township
        case siteAddress = "siteaddress"
        case longitude = "twd97lon"
        case latitude = "twd97lat"
        case siteType = "sitetype"
        case siteId = "siteid"
    }
}
// MARK: - 空氣品質資料模型 （當日
struct TodayAPIResponse: Codable {
    let fields: [Field]
    let resourceId: String
    let extras: Extras
    let includeTotal: Bool
    let total: String
    let resourceFormat: String
    let limit: String
    let offset: String
    let links: Links
    let records: [TodayRecord]
    
    enum CodingKeys: String, CodingKey {
        case fields
        case resourceId = "resource_id"
        case extras = "__extras"
        case includeTotal = "include_total"
        case total
        case resourceFormat = "resource_format"
        case limit
        case offset
        case links = "_links"
        case records
    }
}

struct TodayRecord: Codable {
    let siteName: String
    let county: String
    let aqi: String
    let pollutant: String
    let status: String
    let so2: String
    let co: String
    let o3: String
    let o3_8hr: String
    let pm10: String
    let pm25: String
    let no2: String
    let nox: String
    let no: String
    let windSpeed: String
    let windDirec: String
    let publishTime: String
    let co_8hr: String
    let pm25_avg: String
    let pm10_avg: String
    let so2_avg: String
    let longitude: String
    let latitude: String
    let siteId: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "sitename"
        case county
        case aqi
        case pollutant
        case status
        case so2
        case co
        case o3
        case o3_8hr
        case pm10
        case pm25 = "pm2.5"
        case no2
        case nox
        case no
        case windSpeed = "wind_speed"
        case windDirec = "wind_direc"
        case publishTime = "publishtime"
        case co_8hr
        case pm25_avg = "pm2.5_avg"
        case pm10_avg
        case so2_avg
        case longitude
        case latitude
        case siteId = "siteid"
    }
}

// MARK: - 共用模型
struct Field: Codable {
    let id: String
    let type: String
    let info: FieldInfo
}

struct FieldInfo: Codable {
    let label: String
}

struct Extras: Codable {
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

struct Links: Codable {
    let start: String
    let next: String
}

// MARK: - 監測站位置擴展
extension StationRecord {
    
    var location: CLLocation? {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            print("無法將經緯度轉換為 Double: latitude=" + latitude + ", longitude=" + longitude)
            return nil
        }
        
        return CLLocation(latitude: lat, longitude: lon)
    }

//    func distance(from userLocation: CLLocation) -> CLLocationDistance? {
//        guard let stationLocation = self.location else {
//            return nil
//        }
//        return userLocation.distance(from: stationLocation)
//    }
}

// 在 ViewController 中
enum RecordType {
    case record(Record)
    case detailedRecord(TodayRecord)
}

// 為 RecordType 添加擴展方法，方便取值
extension RecordType {
    var aqi: String {
        switch self {
        case .record(let record):
            return record.aqi
        case .detailedRecord(let detailedRecord):
            return detailedRecord.aqi
        }
    }
    
    var date: String {
        switch self {
        case .record(let record):
            return record.monitorDate
        case .detailedRecord(let detailedRecord):
            return detailedRecord.publishTime
        }
    }
    
    var pm10: String {
        switch self {
        case .record(let record):
            return record.pm10SubIndex
        case .detailedRecord(let detailedRecord):
            return detailedRecord.pm10
        }
    }
    
    var pm25: String {
        switch self {
        case .record(let record):
            return record.pm25SubIndex
        case .detailedRecord(let detailedRecord):
            return detailedRecord.pm25
        }
    }
}
