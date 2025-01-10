//
//  JSONModel.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2025/1/2.
//

import Foundation
import CoreLocation

// MARK: - 空氣品質資料模型
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
