//
//  WeatherDetailViewController.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/7.
//

import UIKit

class WeatherDetailViewController: UIViewController, UIScrollViewDelegate {
    // 新增屬性接收資料
    var records: [Record] = []
    var todayRecords: [TodayRecord] = []
    var stationInfo: (station: StationRecord, distance: Double)?
    
    private var viewControllers: [UIViewController] = []
    
    private lazy var customTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //customTabBarView 外框線
    private lazy var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var weatherTabButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "sun.max")?.resize(to: CGSize(width: 25, height: 25)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(weatherTabButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var detailsTabButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "list.bullet")?.resize(to: CGSize(width: 27, height: 18)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(detailsTabButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scroll.scrollIndicatorInsets = .zero  // 新增這行
        return scroll
    }()
    
    // 更新 cityLabel 的文字
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        // 判斷數據來源並設置站點名稱
        if let stationInfo = stationInfo {
            // 使用 stationInfo 的站點名稱（最近站點）
            label.text = stationInfo.station.siteName
        } else if !todayRecords.isEmpty {
            // 使用今日數據的站點名稱（收藏站點）
            label.text = todayRecords[0].siteName
        } else if !records.isEmpty {
            // 使用歷史數據的站點名稱（收藏站點）
            label.text = records[0].siteName
        } else {
            // 如果都沒有數據，顯示預設文字
            label.text = "無測站資料"
        }
        label.font = .systemFont(ofSize: 35, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow()
        return label
    }()
    
    // 更新 largeAqiLabel 顯示 AQI 值
    private lazy var largeAqiLabel: UILabel = {
        let label = UILabel()
        label.text = todayRecords.first?.aqi ?? records.first?.aqi ?? "0"  // 顯示 AQI 值
        label.font = .systemFont(ofSize: 96, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow()
        return label
    }()
    
    private lazy var aqiUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "(AQI)"  // 顯示 AQI 值
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow()
        return label
    }()
    
    // 先建立一個容器 View
    private lazy var smallLabelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0 // 初始設定為隱藏
        return view
    }()
    
    private lazy var smallAqiLabel: UILabel = {
        let label = UILabel()
        label.text = todayRecords.first?.aqi ?? records.first?.aqi ?? "0"  // 顯示 AQI 值
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow()
        return label
    }()
    
    private lazy var smallAqiUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "(AQI)"  // 顯示 AQI 值
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow()
        return label
    }()
    
    private lazy var smallSeparatorLabel: UILabel = {
        let label = UILabel()
        label.text = "|"  // 顯示 AQI 值
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow()
        return label
    }()
    
    // 新增 AQI 狀態 Label
    private lazy var aqiStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.1)
        // 設定初始值
        if let aqiValue = Int((todayRecords.first?.aqi ?? records.first?.aqi) ?? "0") {
            updateAqiStatus(value: aqiValue, label: label)
        }
        
        return label
    }()
    
    private lazy var smallAqiStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.1)
        // 設定初始值
            if let aqiValue = Int((todayRecords.first?.aqi ?? records.first?.aqi) ?? "0") {
                updateAqiStatus(value: aqiValue, label: label)
            }
        
        return label
    }()
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        //        button.addTarget(self, action: #selector(detailsButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // 上一頁傳遞的空汙數值
    private lazy var pm25Value: String = {
        return todayRecords.first?.pm25 ?? records.first?.pm25SubIndex ?? ""
    }()

    private lazy var pm10Value: String = {
        return todayRecords.first?.pm10 ?? records.first?.pm10SubIndex ?? ""
    }()

    private lazy var o3Value: String = {
        return todayRecords.first?.o3 ?? records.first?.o38SubIndex ?? ""
    }()

    private lazy var coValue: String = {
        return todayRecords.first?.co ?? records.first?.coSubIndex ?? ""
    }()

    private lazy var so2Value: String = {
        return todayRecords.first?.so2 ?? records.first?.so2SubIndex ?? ""
    }()

    private lazy var no2Value: String = {
        return todayRecords.first?.no2 ?? records.first?.no2SubIndex ?? ""
    }()
    
    // MARK: - TableView
    private lazy var airInfoTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
//        table.isScrollEnabled = true  // 禁用 TableView 的滾動
        table.backgroundColor = .black.withAlphaComponent(0.1)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - Constraints
    private var cityLabelTopConstraint: NSLayoutConstraint?
    private var airInfoTableTopConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隱藏 Navigation Bar
        navigationController?.navigationBar.isHidden = true
        // 禁用右滑回上一頁手勢
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setupViews()
        setupConstraints()
        
        setupAirInfoTableView()
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 確保內容高度至少比視圖高度大，這樣才能滾動
        let minContentHeight = view.frame.height + 100
        if scrollView.contentSize.height < minContentHeight {
            scrollView.contentSize.height = minContentHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = UIColor.Weather.Theme.background
        
        view.addSubview(scrollView)
        view.addSubview(customTabBarView)
        view.addSubview(coloredView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(cityLabel)
        contentView.addSubview(largeAqiLabel)
        contentView.addSubview(aqiUnitLabel)
//        contentView.addSubview(smallAqiLabel)
//        contentView.addSubview(smallAqiUnitLabel)
//        contentView.addSubview(smallSeparatorLabel)
        contentView.addSubview(aqiStatusLabel)
//        contentView.addSubview(smallAqiStatusLabel)
        contentView.addSubview(airInfoTableView)
        
        customTabBarView.addSubview(weatherTabButton)
        customTabBarView.addSubview(detailsTabButton)
        
        contentView.addSubview(smallLabelsContainerView)
        
        // 將元件加入容器
        smallLabelsContainerView.addSubview(smallAqiLabel)
        smallLabelsContainerView.addSubview(smallAqiUnitLabel)
        smallLabelsContainerView.addSubview(smallSeparatorLabel)
        smallLabelsContainerView.addSubview(smallAqiStatusLabel)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),  // 改為相對於 safeArea
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: customTabBarView.topAnchor)
            
            
        ])
        
        // ContentView 約束 - 這很重要
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor), // 修改這行
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1500), // 直接設定高度為 1500
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        
        // 所有標籤改為相對於 contentView
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            largeAqiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            largeAqiLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: -10),
            
            aqiUnitLabel.leadingAnchor.constraint(equalTo: largeAqiLabel.trailingAnchor, constant: 3),
            aqiUnitLabel.bottomAnchor.constraint(equalTo: largeAqiLabel.bottomAnchor, constant: -24),
            
//            smallAqiLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
//            smallAqiLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -35),
//            
//            smallAqiUnitLabel.leadingAnchor.constraint(equalTo: smallAqiLabel.trailingAnchor, constant: 1),
//            smallAqiUnitLabel.bottomAnchor.constraint(equalTo: smallAqiLabel.bottomAnchor, constant: -3),
//            
//            smallSeparatorLabel.leadingAnchor.constraint(equalTo: smallAqiUnitLabel.trailingAnchor, constant: 4),
//            smallSeparatorLabel.bottomAnchor.constraint(equalTo: smallAqiLabel.bottomAnchor, constant: -3),
            
            // AQI 狀態 Label 的約束
            aqiStatusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            aqiStatusLabel.topAnchor.constraint(equalTo: largeAqiLabel.bottomAnchor, constant: -3),
            
//            smallAqiStatusLabel.leadingAnchor.constraint(equalTo: smallSeparatorLabel.trailingAnchor, constant: 4),
//            smallAqiStatusLabel.bottomAnchor.constraint(equalTo: smallAqiLabel.bottomAnchor, constant: -2),
            
            // TableView 的約束
            //            tableView.topAnchor.constraint(equalTo: aqiStatusLabel.bottomAnchor, constant: 20),
            airInfoTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            airInfoTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            airInfoTableView.heightAnchor.constraint(equalToConstant: 320)
            
        ])
        
        // smallAQI物件
            NSLayoutConstraint.activate([
                smallLabelsContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                smallLabelsContainerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 50),
                
                // 設定內部元件的約束
                smallAqiLabel.leadingAnchor.constraint(equalTo: smallLabelsContainerView.leadingAnchor),
                smallAqiLabel.centerYAnchor.constraint(equalTo: smallLabelsContainerView.centerYAnchor),
                
                smallAqiUnitLabel.leadingAnchor.constraint(equalTo: smallAqiLabel.trailingAnchor, constant: 1),
                smallAqiUnitLabel.bottomAnchor.constraint(equalTo: smallAqiLabel.bottomAnchor, constant: -3),
                
                smallSeparatorLabel.leadingAnchor.constraint(equalTo: smallAqiUnitLabel.trailingAnchor, constant: 4),
                smallSeparatorLabel.centerYAnchor.constraint(equalTo: smallAqiLabel.centerYAnchor),
                
                smallAqiStatusLabel.leadingAnchor.constraint(equalTo: smallSeparatorLabel.trailingAnchor, constant: 4),
                smallAqiStatusLabel.centerYAnchor.constraint(equalTo: smallAqiLabel.centerYAnchor),
                smallAqiStatusLabel.trailingAnchor.constraint(equalTo: smallLabelsContainerView.trailingAnchor)
            ])
        
        // TabBar 約束
        NSLayoutConstraint.activate([
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarView.heightAnchor.constraint(equalToConstant: 80),
            
            // 在底部添加 coloredView 的約束
            coloredView.bottomAnchor.constraint(equalTo: customTabBarView.topAnchor, constant: 1),
            coloredView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coloredView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coloredView.heightAnchor.constraint(equalToConstant: 1), // 您可以調整高度
            
            // WeatherTab 按鈕約束
            weatherTabButton.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor, constant: 20),
            weatherTabButton.topAnchor.constraint(equalTo: customTabBarView.topAnchor),
            
            // DetailsTab 按鈕約束
            detailsTabButton.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor, constant: -20),
            detailsTabButton.topAnchor.constraint(equalTo: customTabBarView.topAnchor)
        ])
        
        // 設置 cityLabel 的頂部約束，使其在 safe area 內, 50是初始位置
        cityLabelTopConstraint = cityLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 50
        )
        
        cityLabelTopConstraint?.isActive = true
        
        // 設置 airInfoTable 的頂部約束，使其在 safe area 內, 170是初始位置
        airInfoTableTopConstraint = airInfoTableView.topAnchor.constraint(
            equalTo: cityLabel.bottomAnchor,
            constant: 170
        )
        
        airInfoTableTopConstraint?.isActive = true
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //調整的減速行為來讓滾動自然且絲滑, 調整的範圍大約是 0.0（瞬間停止）到 1.0（無限滑動）
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 1)
        
        // aqiStatusLabel 在前 30 點距離內快速消失 (0-30)
        let statusLabelAlpha = max(0, 1 - (offsetY / 30))
        aqiStatusLabel.alpha = statusLabelAlpha
        
        // largeAqiLabel 在接下來的 40 點距離內消失 (30-70)
        let largeAqiAlpha = max(0, 1 - ((offsetY - 30) / 40))
        largeAqiLabel.alpha = offsetY < 30 ? 1 : largeAqiAlpha
        aqiUnitLabel.alpha = largeAqiLabel.alpha
        
        // 小標籤漸變效果（70-100）
        let smallAqiAlpha = offsetY > 70 ?
        min(1, (offsetY - 70) / 30) : 0
//        smallAqiLabel.alpha = smallAqiAlpha
//        smallAqiUnitLabel.alpha = smallAqiAlpha
//        smallSeparatorLabel.alpha = smallAqiAlpha
//        smallAqiStatusLabel.alpha = smallAqiAlpha
        smallLabelsContainerView.alpha = smallAqiAlpha
        
        
        // cityLabel 位置計算
        let initialPosition: CGFloat = 50  // 初始位置
        let safeAreaInset = view.safeAreaInsets.top // safe area 的高度
        let offsetAdjustment: CGFloat = 50  // 增加此值讓最終位置更高
        let newPosition = max(safeAreaInset - offsetAdjustment, initialPosition - offsetY)
        cityLabelTopConstraint?.constant = newPosition
        
        // 確保 largeAqiLabel 也隨之移動
        let tableViewInitialPosition: CGFloat = 170 // 初始位置
        let tableViewoffsetAdjustment: CGFloat = -15  // 增加此值讓最終位置更高
        let tableViewnewPosition = max(safeAreaInset - tableViewoffsetAdjustment, tableViewInitialPosition - offsetY)
        airInfoTableTopConstraint?.constant = tableViewnewPosition
        
        // 強制更新佈局
        view.layoutIfNeeded()
    }
    
    
    @objc private func weatherTabButtonTapped(_ sender: UIButton) {
        // 處理天氣頁面的切換邏輯
    }
    
    @objc private func detailsTabButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // 新增判斷 AQI 狀態的方法
    private func updateAqiStatus(value: Int, label: UILabel) {
        switch value {
        case 0...50:
            label.text = "良好"
            label.textColor = UIColor.Weather.AQI.good
        case 51...100:
            label.text = "普通"
            label.textColor = UIColor.Weather.AQI.moderate
        case 101...150:
            label.text = "對敏感族群不健康"
            label.textColor = UIColor.Weather.AQI.unhealthyForSensitive
        case 151...200:
            label.text = "對所有族群不健康"
            label.textColor = UIColor.Weather.AQI.unhealthy
        case 201...300:
            label.text = "非常不健康"
            label.textColor = UIColor.Weather.AQI.veryUnhealthy
        case 301...400:
            label.text = "危害"
            label.textColor = UIColor.Weather.AQI.hazardous1
        case 401...500:
            label.text = "危害"
            label.textColor = UIColor.Weather.AQI.hazardous2
        default:
            label.text = "無資料"
            label.textColor = UIColor.Weather.AQI.noData
        }
    }
    
    func setupAirInfoTableView() {
        airInfoTableView.delegate = self
        airInfoTableView.dataSource = self
        
        // 註冊自定義 Cell
        airInfoTableView.register(AirInfoTableViewCell.self, forCellReuseIdentifier: "AirInfoCell")
        
        
        airInfoTableView.layer.cornerRadius = 20 // 圓角
        airInfoTableView.rowHeight = 44 // 可以根據需要調整高度
        
        // 設定 style 屬性
        airInfoTableView.sectionHeaderTopPadding = 1  // iOS 15 及以上
    }
}

// 實作 UITableViewDelegate 和 UITableViewDataSource
extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 // 先回傳固定數量，之後可以依據資料調整
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "日空氣品質指標(AQI)"
    }
    
    // 設定 header 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40  // 或您需要的高度
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AirInfoCell", for: indexPath) as? AirInfoTableViewCell else {
            return UITableViewCell()
        }
        
        // 創建帶有下標的標籤
        func createLabelWithSubscript(_ mainText: String, subscriptText: String) -> NSAttributedString {
            let mainAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
            ]
            
            let subscriptAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .baselineOffset: -3 // 調整上標位置
            ]
            
            let attributedString = NSMutableAttributedString()
            
            attributedString.append(NSAttributedString(string: mainText, attributes: mainAttributes))
            attributedString.append(NSAttributedString(string: subscriptText, attributes: subscriptAttributes))
            
            return attributedString
            
            
        }
        
        // 根據 indexPath.row 設置不同的內容
        switch indexPath.row {
        case 0:
            cell.configure(
                mainText: createLabelWithSubscript("PM", subscriptText: "2.5"),
                airValueText: "\(pm25Value)",
                unitText: "(μg/m³)"
            )
        case 1:
            cell.configure(
                mainText: createLabelWithSubscript("PM", subscriptText: "10"),
                airValueText: "\(pm10Value)",
                unitText: "(μg/m³)"
            )
        case 2:
            cell.configure(
                mainText: createLabelWithSubscript("O", subscriptText: "3"),
                airValueText: "\(o3Value)",
                unitText: "(ppb)"
            )
        case 3:
            cell.configure(
                mainText: createLabelWithSubscript("CO", subscriptText: ""),
                airValueText: "\(coValue)",
                unitText: "(ppb)"
            )
        case 4:
            cell.configure(
                mainText: createLabelWithSubscript("SO", subscriptText: "2"),
                airValueText: "\(so2Value)",
                unitText: "(ppb)"
            )
        case 5:
            cell.configure(
                mainText: createLabelWithSubscript("NO", subscriptText: "2"),
                airValueText: "\(no2Value)",
                unitText: "(ppb)"
            )
        default:
            cell.configure(
                mainText: NSAttributedString(string: "無效資料"),
                airValueText: "",
                unitText: ""
            )
        }
        
        return cell
    }
}

