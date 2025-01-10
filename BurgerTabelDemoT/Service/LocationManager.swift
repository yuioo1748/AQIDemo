//
//  LocationManager.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2025/1/2.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // 新增一個閉包來處理位置更新
    var locationUpdateHandler: ((CLLocation) -> Void)?
    
    // 限制更新頻率
    private var lastUpdateTimestamp: Date?
    private let minimumUpdateInterval: TimeInterval = 60 // X 秒內更新一次
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // 檢查是否已經有授權
        checkLocationAuthorization()
    }
    
    // 新增授權狀態檢查方法
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("位置權限被拒絕或受限制")
        @unknown default:
            break
        }
    }
    
    func startUpdatingLocation() {
        // 檢查是否已獲得授權
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
           locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            checkLocationAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // 處理授權狀態變更
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 檢查是否在最小更新間隔內
        if let lastUpdate = lastUpdateTimestamp,
           Date().timeIntervalSince(lastUpdate) < minimumUpdateInterval {
            return
        }
        
        currentLocation = location
        lastUpdateTimestamp = Date()
        locationUpdateHandler?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置更新失敗：\(error.localizedDescription)")
    }
}
