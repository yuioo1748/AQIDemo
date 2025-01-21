//
//  SearchViewController.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/16.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - 首先在 SearchViewController 類別開頭加入
    private let favoriteStationsKey = "FavoriteStations"
    static let favoriteStationDidSaveNotification = Notification.Name("FavoriteStationDidSave")
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "請輸入搜尋內容"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private var stationNames: [String] = []
    private var filteredItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        getStations()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        // 加入搜尋欄
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // 加入表格視圖
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - 新增儲存站點的方法
    private func saveFavoriteStation(_ stationName: String) {
        // 從 UserDefaults 取得現有的站點陣列，如果沒有就建立空陣列
        var favoriteStations = UserDefaults.standard.stringArray(forKey: favoriteStationsKey) ?? []
        
        // 檢查是否已經存在相同的站點
        guard !favoriteStations.contains(stationName) else {
            // 如果已經存在，可以顯示提示訊息
            showAlert(message: "此站點已經加入列表")
            return
        }
        
        // 加入新站點
        favoriteStations.append(stationName)
        // 儲存更新後的陣列
        UserDefaults.standard.set(favoriteStations, forKey: favoriteStationsKey)
        
        // 發送通知
        NotificationCenter.default.post(
            name: SearchViewController.favoriteStationDidSaveNotification,
            object: nil,
            userInfo: ["stationName": stationName]
        )
        
        // 顯示成功訊息
        showAlert(message: "已成功加入列表")
    }
    
    // MARK: - 新增顯示提示訊息的方法
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = []
        } else {
            filteredItems = stationNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredItems[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 取得選擇的站點名稱
        let selectedStation = filteredItems[indexPath.row]
        
        // 儲存到 UserDefaults
        saveFavoriteStation(selectedStation)
    }
}

// MARK: - 取得所有站點
extension SearchViewController {
    
    func getStations() {
        RestManager.shared.getStations { result in
            switch result {
            case .success(let stationResponse):
                // 從回應中提取站名
                let siteNames = stationResponse.records.map { $0.siteName }
                
                // 將站名儲存或使用
                self.stationNames = siteNames
                //                print("站點名稱：\(siteNames)")
                
            case .failure(let error):
                print("獲取站點資料失敗：\(error)")
            }
        }
        
    }
    
    // 跳轉到詳細頁面的方法
    @objc private func navigateSearchViewController() {
        // 創建要跳轉的頁面
        let searchVC = SearchViewController() // 替換為你的 ViewController
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}
