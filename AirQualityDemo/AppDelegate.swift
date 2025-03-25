//
//  AppDelegate.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2024/12/25.
//

import UIKit
import CoreLocation
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let locationManager = LocationManager.shared
    private let airQualityUpdateInterval: TimeInterval = 10 * 60 // 2分鐘更新一次
    private let identifier = "com.andyTest.AirQuality.refresh"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.checkLocationAuthorization()
        registerBackgroundTask()
        startAQIDataUpdate()
        scheduleAppRefresh()
        
        return true
    }
    
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            print("Background task registered successfully")
            
            // 檢查 task 類型並安全轉型
            if let appRefreshTask = task as? BGAppRefreshTask {
                self.handleAppRefresh(task: appRefreshTask)
            } else {
                print("Unexpected task type")
            }
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: airQualityUpdateInterval) // 15分鐘
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("App refresh scheduled successfully")
        } catch {
            print("Could not schedule app refresh: \(error)")
            print("Error details: \(error.localizedDescription)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        if let location = locationManager.currentLocation {
            updateAQIData(with: location)
        }
        
        task.setTaskCompleted(success: true)
        scheduleAppRefresh()
    }
    
    func startAQIDataUpdate() {
        DispatchQueue.main.async { [weak self] in
            // 確保這行在主執行緒執行
            let isInBackground = UIApplication.shared.applicationState == .background

            DispatchQueue.global(qos: .background).async {
                guard isInBackground else {
                    print(" App 在前景，不進行背景 AQI 更新")
                    return
                }

                self?.locationManager.locationUpdateHandler = { location in
                    DispatchQueue.main.async { // 回到主執行緒更新 UI
                        self?.updateAQIData(with: location)
                    }
                }
                self?.locationManager.startUpdatingLocation()
            }
        }
    }


    
    private func updateAQIData(with location: CLLocation) {
        DispatchQueue.main.async {
            guard UIApplication.shared.applicationState == .background else {
                print(" App 在前景，跳過 AQI 更新")
                return
            }

            RestManager.shared.getAirQualityWithLocation(userLocation: location) { result in
                switch result {
                case .success(let stations):
                    if let nearest = stations.first {
                        let record = nearest.0
                        let station = nearest.1
                        
                        AirQualityDataManager.shared.saveLatestAQIData(
                            aqi: record.aqi,
                            status: record.status,
                            siteName: station.siteName,
                            pm25: record.pm25,
                            pm10: record.pm10,
                            o3: record.o3,
                            co: record.co,
                            so2: record.so2,
                            no2: record.no2
                        )
                        print(" AQI 更新成功（背景模式）")
                    }
                case .failure(let error):
                    print(" AQI 更新失敗: \(error)")
                }
            }
        }
    }

    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
