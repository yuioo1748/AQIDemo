//
//  RestManager.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2025/1/2.
//

import Alamofire
import Foundation
import CoreLocation

// MARK: - 協議定義
/// API設定協議，定義基本的API請求參數
protocol APIConfiguration {
    var method: HTTPMethod { get }      // HTTP請求方法
    var path: String { get }            // API路徑
    var parameters: Parameters? { get } // 請求參數
    var headers: HTTPHeaders? { get }   // 請求標頭
}

// MARK: - 網路請求管理器
class RestManager {
    // MARK: - 屬性
    /// 單例模式
    static let shared = RestManager()
    
    
    /// API基礎URL
    private let baseURL = "https://data.moenv.gov.tw/api/"
    
    /// 預設的請求標頭
    private var defaultHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    let yourAPIKey: String = ""
    
    /// 當前執行中的請求任務
    private var currentTasks: [String: DataRequest] = [:]
    
    /// 任務隊列，用於管理請求
    private let taskQueue = DispatchQueue(label: "com.restmanager.queue")
    
    // MARK: - 公開方法
    /// 發送網路請求的通用方法
    func request<T: Decodable>(_ configuration: APIConfiguration, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL + configuration.path
        let headers = configuration.headers ?? defaultHeaders
        
        // 根據請求方法選擇適當的編碼方式
        let encoding: ParameterEncoding = configuration.method == .get ? URLEncoding.default : JSONEncoding.default
        
        let request = AF.request(
            url,
            method: configuration.method,
            parameters: configuration.parameters,
            encoding: encoding,     // 使用動態決定的編碼方式
            headers: headers
        )
            .validate()
            .responseDecodable(of: T.self) { [weak self] response in
                self?.handleResponse(response, completion: completion)
            }
        
        trackRequest(request)
    }
    
    // MARK: - 任務管理
    /// 取消所有請求任務
    func cancelAllTasks() {
        taskQueue.async {
            self.currentTasks.values.forEach { $0.cancel() }
            self.currentTasks.removeAll()
        }
    }
    
    /// 取消特定ID的請求任務
    func cancelTask(with id: String) {
        taskQueue.async {
            self.currentTasks[id]?.cancel()
            self.currentTasks.removeValue(forKey: id)
        }
    }
    
    // MARK: - 私有方法
    /// 追蹤請求任務
    private func trackRequest(_ request: DataRequest) {
        let requestId = UUID().uuidString
        taskQueue.async {
            self.currentTasks[requestId] = request
        }
    }
    
    /// 處理請求回應
    private func handleResponse<T: Decodable>(_ response: AFDataResponse<T>, completion: @escaping (Result<T, Error>) -> Void) {
        switch response.result {
        case .success(let value):
            completion(.success(value))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

// MARK: - API配置
/// 空氣品質指標API配置
struct AQIConfiguration: APIConfiguration {
    let method: HTTPMethod = .get
    let path: String
    let parameters: Parameters?
    var headers: HTTPHeaders?
    
    init(limit: Int = 3) {
        let apiKey = RestManager.shared.yourAPIKey.lazy
        self.path = "v2/aqx_p_434"
        self.parameters = [
            "api_key": "\(apiKey)",
            "limit": String(limit)
        ]
    }
}

/// 空氣品質監測站基本資料
struct StationConfiguration: APIConfiguration {
    let method: HTTPMethod = .get
    let path: String
    let parameters: Parameters?
    var headers: HTTPHeaders?
    
    init(limit: Int = 1000) {  // 預設取得所有測站資料
        let apiKey = RestManager.shared.yourAPIKey.lazy
        self.path = "v2/aqx_p_07"
        self.parameters = [
            "api_key": "\(apiKey)",
            "limit": String(limit)
        ]
    }
}

// MARK: - 便利方法
extension RestManager {
    
    /// 獲取空氣品質資料的便利方法
    func getAQIData(limit: Int = 1000, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let configuration = AQIConfiguration(limit: limit)
        request(configuration, completion: completion)
    }
    
    /// 獲取空氣品質偵測站資料的便利方法
    func getStations(limit: Int = 1000,  completion: @escaping (Result<StationResponse, Error>) -> Void){
        let configuration = StationConfiguration(limit: limit)
        request(configuration, completion: completion)
    }
    
    
    /// 整合基本資料和即時資料
    func getAirQualityWithLocation(userLocation: CLLocation, completion: @escaping (Result<[(Record, StationRecord, Double)], Error>) -> Void) {
        print("使用者位置: 緯度 " + String(userLocation.coordinate.latitude) + ", 經度 " + String(userLocation.coordinate.longitude))
        
        // 取得所有監測站的資料
        getStations { [weak self] stationResult in
            switch stationResult {
            case .success(let stationResponse):
                print("總站點數: " + String(stationResponse.records.count))
                
                // 繼續取得 AQI（空氣品質指標）數據
                self?.getAQIData(limit: 1000) { aqiResult in
                    switch aqiResult {
                    case .success(let aqiResponse):
                        print("總AQI資料數: " + String(aqiResponse.records.count))
                        
                        // 用於儲存符合條件的監測站與其對應的 AQI 資料及距離
                        var results: [(Record, StationRecord, Double)] = []
                        
                        // 遍歷所有監測站資料
                        for station in stationResponse.records {
                            // 確認監測站是否有位置資訊
                            if let stationLocation = station.location {
                                // 計算使用者位置與監測站之間的距離
                                let distance = userLocation.distance(from: stationLocation)
                                
                                // 如果距離在50公里內
                                if distance <= 50000 {
                                    // 檢查是否有對應的AQI資料
                                    if let matchingRecord = aqiResponse.records.first(where: { $0.siteId == station.siteId }) {
                                        // 將匹配到的資料（AQI 資料、監測站資料、距離）加入結果陣列
                                        results.append((matchingRecord, station, distance))
                                    }
                                }
                            }
                        }
                        
                        //根據元組的第3個元素去排列 （<，升序，小到大）
                        let sortedResults = results.sorted { $0.2 < $1.2 }
                        
                        // 只取第一個（最近的）站點
                        let nearestResult = sortedResults.first.map { [$0] } ?? []
                        
                        print("找到 " + String(nearestResult.count) + " 個最近站點")
                        
                        // 將結果以成功的方式傳回給 completion
                        completion(.success(nearestResult))
                        
                    case .failure(let error):
                        // AQI 資料獲取失敗，將錯誤傳回
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                // 監測站資料獲取失敗，將錯誤傳回
                completion(.failure(error))
            }
        }
    }
}
