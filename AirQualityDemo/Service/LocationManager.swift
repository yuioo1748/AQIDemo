//
//  LocationManager.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/2.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var lastUpdateTimestamp: Date?
    
    var currentLocation: CLLocation?
    var locationUpdateHandler: ((CLLocation) -> Void)?
    
    // 限制更新頻率（秒）
    private let minimumUpdateInterval: TimeInterval = 60

    override private init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    // 檢查並請求授權
    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            // 主線程請求授權
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied:
            print("位置權限被拒絕或受限制，請前往設定開啟權限")
        @unknown default:
            print("未知的授權狀態")
        }
    }
    
    // 開始更新位置
    func startUpdatingLocation() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard CLLocationManager.locationServicesEnabled() else {
                print("位置服務未啟用")
                return
            }
            
            let status = self?.locationManager.authorizationStatus ?? .notDetermined
            
            DispatchQueue.main.async {
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.locationManager.startUpdatingLocation()
                } else {
                    self?.checkLocationAuthorization()
                }
            }
        }
    }
    
    // 停止更新位置
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 檢查是否在最小更新間隔內
        if let lastUpdate = lastUpdateTimestamp, Date().timeIntervalSince(lastUpdate) < minimumUpdateInterval {
            return
        }
        
        lastUpdateTimestamp = Date()
        currentLocation = location
        
        // 在背景線程處理位置更新
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.locationUpdateHandler?(location)
            
            // 🔥 發送通知給 SchedulePageVC
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("LocationUpdated"), object: nil, userInfo: ["location": location])
            }
        }
        
        print("位置更新：\(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("使用者拒絕了位置存取權限")
            case .locationUnknown:
                print("目前無法獲取位置")
            default:
                print("位置更新失敗：\(clError.localizedDescription)")
            }
        } else {
            print("位置更新錯誤：\(error.localizedDescription)")
        }
    }
}

