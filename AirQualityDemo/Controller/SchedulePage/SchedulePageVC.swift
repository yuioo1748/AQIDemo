//
//  SchedulePageVC.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2024/12/27.
//

import UIKit
import FSCalendar
import CoreLocation

class SchedulePageVC: UIViewController {
    private let locationManager = LocationManager.shared
    private let today = Date()
    
    private let stationFetchSemaphore = DispatchSemaphore(value: 0)
    
    let backButton = UIButton(type: .custom)
    let img = UIImage(named: "backBtn")?.resize(to: CGSize(width: 8, height: 16)) // 調整圖片大小
    
    var _monthLabel = UILabel() //日曆按鈕，顯示月份
    var _monthChevronImgView = UIImageView() //日曆按鈕，顯示展開或收起
    private let chevronWidth: CGFloat = 12 // 新的寬度
    private let chevronHeight: CGFloat = 12 // 高度保持不變
    
    private var isCalendarExpanded = false // 記錄日曆是否展開
    
    // 使用靜態方法初始化圖片
    private lazy var calendarTodayImg: UIImageView = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" // 只取月份
        let dayString = dateFormatter.string(from: today) // 取得當前顯示月份
        
        let imageView = UIImageView(image: SchedulePageVC.createCalendarImageWithText(text: "\(dayString)"))
        return imageView
    }()
    
    let addButton = UIButton(type: .custom)
    let addImg = UIImage(named: "plus")?.resize(to: CGSize(width: 16, height: 16)) // 調整圖片大小
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var tableViewTopConstraint: NSLayoutConstraint = {
        return tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
    }()
    
    private lazy var tableViewCalendarExpandedConstraint: NSLayoutConstraint = {
        return tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10)
    }()
    
    // 修改屬性以存儲測站和距離
    var nearestStationInfo: (station: StationRecord, distance: Double)?
    
    // 資料源
    // 新增一個屬性存儲篩選後的記錄
    var filteredAqiRecords: [Record] = [] //非當日AQI
    var filteredTodayAqiRecords: [TodayRecord] = [] //當日AQI
    
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        // 設定起始日期
        
        calendar.select(today)  // 選擇起始日期
        calendar.setCurrentPage(today, animated: false)  // 設定顯示的月份頁面
        
        //外觀設定
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 18) // 設定標題字型
        calendar.appearance.headerTitleColor = .black //2024年12的文字顏色
        calendar.appearance.titleDefaultColor = .black //一般日期的顏色
        calendar.appearance.titleTodayColor = .black //今天日期的顏色
        calendar.appearance.titleSelectionColor = .black  // 選取時的文字顏色
        
        calendar.appearance.todayColor = .lightGray //今天的底色
        calendar.appearance.selectionColor = .clear //選取時的底色
        calendar.appearance.todaySelectionColor = .lightGray // 如果選到今天，要用今天的底色
        calendar.appearance.weekdayTextColor = .black //週一到週日的文字顏色
        calendar.appearance.borderSelectionColor = .brown //選曲時的邊框線條顏色
        calendar.appearance.borderRadius = 0.4  // 邊框圓角程度（0 到 1）
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 隱藏上下月份的標題
        
        calendar.allowsMultipleSelection = false
        calendar.appearance.headerDateFormat = "YYYY年MM月" // 顯示格式
        calendar.locale = Locale(identifier: "zh_TW")
        
        // 初始狀態設為隱藏
        calendar.isHidden = true
        calendar.alpha = 0
        
        return calendar
    }()
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置月份按鈕
        setLeftBarButtonItems()
        setRightBarButtonItems()
        setupCalendar()
        setupTableView()  // 新增此行
        
        // 新增這段程式碼
        tableViewTopConstraint.isActive = true
        tableViewCalendarExpandedConstraint.isActive = false
        
        locationManager.startUpdatingLocation()
        findNearestStation()
        
    }
    
    private func setRightBarButtonItems() {
        
        // MARK: - 顯示當日日期
        calendarTodayImg.contentMode = .scaleAspectFit
        calendarTodayImg.frame = CGRect(x: 0, y: 0, width: 32, height: 32) // 設定圖片大小
        
        // 創建一個容器視圖來包裝圖片
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        containerView.addSubview(calendarTodayImg)
        calendarTodayImg.center = CGPoint(x: containerView.bounds.width - (calendarTodayImg.bounds.width/2), y: containerView.bounds.height/2)
        
        let todayImage = UIBarButtonItem(customView: containerView)
        
        // MARK: - 加號按鈕
        addButton.setImage(addImg, for: .normal)
        addButton.setTitle(" ", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        //        addButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        // 設置按鈕的邊距
        addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 調整按鈕邊距
        addButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // 設定 UIButton 為 UIBarButtonItem 的 customView
        let addButtonImage = UIBarButtonItem(customView: addButton)
        
        
        
        navigationItem.rightBarButtonItems = [addButtonImage, todayImage]
        
    }
    
    //客製化展開收起日曆按鈕
    private func setLeftBarButtonItems() {
        
        // MARK: - 回上一頁按鈕
        backButton.setImage(img, for: .normal)
        backButton.setTitle(" ", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        // 設置按鈕的邊距
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 調整按鈕邊距
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // 設定 UIButton 為 UIBarButtonItem 的 customView
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        // MARK: - 展開與收起日曆
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM" // 只取月份
        let monthString = dateFormatter.string(from: calendar.currentPage) // 取得當前顯示月份
        
        
        _monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        _monthLabel.adjustsFontSizeToFitWidth = true // 允許文字大小自動調整以適應寬度
        _monthLabel.textAlignment = .left  // 文字左對齊
        _monthLabel.textColor = .white  // 文字顏色設為白色
        _monthLabel.font = .init(name: "HelveticaNeue-Bold", size: 16)  // 設定粗體字型
        _monthLabel.text = "\(monthString)月"  // 設定預設文字
        
        
        // 創建月份旁的向下箭頭圖示
        _monthChevronImgView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 12))
        //        _monthChevronImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightButtonTapped)))
        if let img = UIImage(named: "chevron-down")?.resize(to: CGSize(width: 16, height: 12))
        {
            _monthChevronImgView.image = img.withRenderingMode(.alwaysTemplate) // 設置渲染模式
            _monthChevronImgView.tintColor = .white // 設定圖片為白色
            _monthChevronImgView.translatesAutoresizingMaskIntoConstraints = false
            _monthChevronImgView.widthAnchor.constraint(equalToConstant: chevronWidth).isActive = true
            _monthChevronImgView.heightAnchor.constraint(equalToConstant: chevronHeight).isActive = true
        }
        
        // 創建水平方向的堆疊視圖，包含月份標籤和箭頭圖示
        let stackView = UIStackView(arrangedSubviews: [_monthLabel, _monthChevronImgView])
        stackView.axis = .horizontal  // 設定為水平排列
        stackView.spacing = 0  // 元件間距設為 0
        stackView.alignment = .center  // 垂直置中對齊
        stackView.backgroundColor = .clear  // 背景透明
        stackView.translatesAutoresizingMaskIntoConstraints = false  // 使用自動佈局約束
        
        // 創建一個容器視圖，作為堆疊視圖的外層容器
        let containerView = UIView()
        containerView.backgroundColor = .black  // 設定背景為黑色
        containerView.layer.cornerRadius = 16  // 設定圓角
        containerView.isUserInteractionEnabled = true  // 啟用使用者互動
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftButtonTapped)))
        containerView.addSubview(stackView)
        
        // 設定自動佈局約束
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),  // 上邊緣對齊
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),  // 下邊緣對齊
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),  // 左邊距 10 點
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),  // 右邊距 10 點
            containerView.widthAnchor.constraint(greaterThanOrEqualTo: stackView.widthAnchor, constant: 20),  // 容器寬度至少比堆疊視圖寬 20 點
            containerView.heightAnchor.constraint(equalToConstant: 32),  // 容器高度固定 32 點
            stackView.heightAnchor.constraint(equalToConstant: 32)  // 堆疊視圖高度固定 32 點
        ])
        let stackButton = UIBarButtonItem(customView: containerView)  // 將容器視圖轉換為導航欄按鈕項目
        
        // 設置導航欄左側的按鈕項目：返回按鈕和月份選擇按鈕
        navigationItem.leftBarButtonItems = [backButtonItem, stackButton]
        //        }
    }
    
    private func setupCalendar() {
        
        // 添加 FSCalendar 到視圖
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // 直接設定星期標籤
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        for (index, weekday) in weekdays.enumerated() {
            calendar.calendarWeekdayView.weekdayLabels[index].text = weekday
            
        }
        
    }
    
    @objc func leftButtonTapped() {
        isCalendarExpanded.toggle()
        
        // 根據展開狀態更換圖片
        if let img = UIImage(named: isCalendarExpanded ? "chevron-up" : "chevron-down")?.resize(to: CGSize(width: 16, height: 12)) {
            _monthChevronImgView.image = img.withRenderingMode(.alwaysTemplate)
        }
        
        if isCalendarExpanded {
            // 展開日曆
            calendar.isHidden = false
            
            // 停用預設約束，啟用展開約束
            tableViewTopConstraint.isActive = false
            tableViewCalendarExpandedConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.calendar.alpha = 1
                self.view.layoutIfNeeded() // 觸發佈局更新
            } completion: { _ in
                self.calendar.reloadData()
                
            }
        } else {
            // 收起日曆
            // 停用展開約束，啟用預設約束
            tableViewCalendarExpandedConstraint.isActive = false
            tableViewTopConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.calendar.alpha = 0
                self.view.layoutIfNeeded() // 觸發佈局更新
            } completion: { _ in
                self.calendar.isHidden = true
                
            }
        }
    }
    private static func createCalendarImageWithText(text: String) -> UIImage? {
        guard let originalImage = UIImage(named: "calendar") else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(originalImage.size, false, 0.0)
        originalImage.draw(in: CGRect(origin: .zero, size: originalImage.size))
        
        // 調整文字屬性 - 增加字體大小
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 180), // 大幅增加字體大小
            .foregroundColor: UIColor.black
        ]
        
        let textSize = text.size(withAttributes: textAttributes)
        
        // 調整文字位置 - 針對 448x512 的圖片調整位置
        let textRect = CGRect(
            x: (originalImage.size.width - textSize.width) / 2,
            y: (originalImage.size.height - textSize.height) / 2 + 50, // 往下移動更多
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: textAttributes)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    @objc func handleBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // 註冊自定義 Cell
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 取消分隔線
        tableView.separatorStyle = .none
        
        // 註冊自定義 Cell
        tableView.register(AQITableViewCell.self, forCellReuseIdentifier: "AQICell")
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
}

// MARK: - Calendar
extension SchedulePageVC:FSCalendarDelegate, FSCalendarDataSource  {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 將 UTC 日期轉換為本地日期
        let localDate = date.convertToLocalDate()
        
        // 確保有最近的測站資訊
        guard let nearestStationInfo = nearestStationInfo else {
            print("尚未取得最近的測站")
            return
        }
        
        // 建立日期格式器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        // 轉換日期為字串
        let selectedDateString = dateFormatter.string(from: date)
        let todayDateString = dateFormatter.string(from: today)
        
        if selectedDateString == todayDateString {
            // 查詢 AQI 資料 (當日
            RestManager.shared.getTodayAQIData(limit: 1000) { [weak self] result in
                switch result {
                case .success(let response):
                    // 篩選特定日期和測站的資料
                    self?.filteredTodayAqiRecords = response.records.filter { record in
                        record.siteId == nearestStationInfo.station.siteId
                    }
                    
                    // 重置非當日資料
                                        self?.filteredAqiRecords = []
                    
                    // 重新載入 TableView
                                       DispatchQueue.main.async {
                                           self?.tableView.reloadData()
                                       }
                    
                case .failure(let error):
                    print("錯誤: \(error)")
                }
            }
        } else{
            // 查詢 AQI 資料 (非當日
            RestManager.shared.getAQIData(limit: 1000) { [weak self] result in
                switch result {
                case .success(let response):
                    // 篩選特定日期和測站的資料
                    self?.filteredAqiRecords = response.records.filter { record in
                        record.monitorDate.hasPrefix(selectedDateString) &&
                        record.siteId == nearestStationInfo.station.siteId
                        
                    }
                    // 重置當日資料
                                        self?.filteredTodayAqiRecords = []
                                        
                                        // 重新載入 TableView
                                        DispatchQueue.main.async {
                                            self?.tableView.reloadData()
                                        }
                    
                case .failure(let error):
                    print("錯誤: \(error)")
                }
            }
        }
    }
}

// MARK: - TableView
extension SchedulePageVC:UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //優先顯示當日資料，如果沒有當日資料，則顯示歷史資料
               return !filteredTodayAqiRecords.isEmpty ? filteredTodayAqiRecords.count :
                      !filteredAqiRecords.isEmpty ? filteredAqiRecords.count : 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "空氣品質指標AQI"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AQICell", for: indexPath) as? AQITableViewCell,
              let nearestStationInfo = nearestStationInfo else {
            return UITableViewCell()
        }
        // 判斷要使用哪個資料源
            let recordType: RecordType
        
        // 根據當前選擇的日期是否為今天來決定使用哪個資料源
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = dateFormatter.string(from: calendar.selectedDate ?? today)
        let todayDateString = dateFormatter.string(from: today)
        
        if selectedDateString == todayDateString || !filteredTodayAqiRecords.isEmpty {
            // 如果選擇的是今天，且有當日資料，優先使用當日資料
            recordType = .detailedRecord(filteredTodayAqiRecords[indexPath.row])
        } else {
            // 否則使用非當日資料
                    recordType = .record(filteredAqiRecords[indexPath.row])
        }
        
        cell.configure(
                stationName: nearestStationInfo.station.siteName,
                distance: nearestStationInfo.distance,
                aqi: recordType.aqi,
                date: "", //先不顯示
                pm10: recordType.pm10,
                pm25: recordType.pm25,
                recordType: recordType
            )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取得被選中的 Cell
        guard let cell = tableView.cellForRow(at: indexPath) as? AQITableViewCell else { return }
        
        
        // 執行展開動畫
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            // 動畫完成後恢復原狀
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .identity
            }) { _ in
                
                // 跳轉到詳細頁面
                self.navigateToDetailPage(for: indexPath)
            }
        }
    }
    
    
    // 跳轉到詳細頁面的方法
    private func navigateToDetailPage(for indexPath: IndexPath) {
        // 創建要跳轉的頁面
        let detailVC = WeatherDetailViewController() // 替換為你的 ViewController
        
        // 傳遞資料
        detailVC.records = self.filteredAqiRecords
        detailVC.todayRecords = self.filteredTodayAqiRecords
        detailVC.stationInfo = self.nearestStationInfo
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

// MARK: - 打api取值
extension SchedulePageVC {
    
    func findNearestStation() {
        // 先檢查是否有位置資訊
        if locationManager.currentLocation == nil {
            // 設置位置更新的處理程序
            locationManager.locationUpdateHandler = { [weak self] location in
                self?.fetchAirQualityData(with: location)
            }
            // 開始更新位置
            locationManager.startUpdatingLocation()
        } else {
            // 如果已經有位置資訊，直接獲取空氣品質資料
            if let location = locationManager.currentLocation {
                fetchAirQualityData(with: location)
            }
        }
    }
    
    // 取得最近測站和最近距離，在 findNearestStation 中加入更多偵錯
    private func fetchAirQualityData(with location: CLLocation) {
        print("----(進畫面取得)------------------------------------")
        //        print("使用者位置：\(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        RestManager.shared.getAirQualityWithLocation(userLocation: location) { [weak self] result in
            switch result {
            case .success(let stations):
                if let nearest = stations.first {
                    // 同時保存最近測站和距離
                    self?.nearestStationInfo = (nearest.1, nearest.2)
                    
                    let record = nearest.0
                    let station = nearest.1
                    let distance = nearest.2
                    
                    print("最近的測站：\(station.siteName)")
                    print("距離：\(Int(distance/1000))公里")
                    print("AQI：\(record.aqi)")
                    // 載入當日 AQI 資料
                                    DispatchQueue.main.async {
                                        self?.loadTodayAQIData()
                                        self?.tableView.reloadData()
                                    }
                                }
                            case .failure(let error):
                                print("錯誤：\(error)")
                            }
                        }
                    }
 
    // 新增這個方法
    func loadTodayAQIData() {
        // 確保有最近的測站資訊
        guard let nearestStationInfo = nearestStationInfo else {
            print("尚未取得最近的測站")
            return
        }
        
        // 查詢 AQI 資料 (當日)
        RestManager.shared.getTodayAQIData(limit: 1000) { [weak self] result in
            switch result {
            case .success(let response):
                // 篩選特定測站的資料
                self?.filteredTodayAqiRecords = response.records.filter { record in
                    record.siteId == nearestStationInfo.station.siteId
                    
                }
                
                // 使用篩選後的第一筆資料
                           if let firstRecord = self?.filteredTodayAqiRecords.first {
                               // 例如在獲取 AQI 資料後
                               AirQualityDataManager.shared.saveLatestAQIData(
                                   aqi: firstRecord.aqi,
                                   status: firstRecord.status,
                                   siteName: nearestStationInfo.station.siteName
                               )
                           }
                
                // 更新 TableView
                DispatchQueue.main.async {
                    // 更新 TableView 使用 Today 的資料
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("當日 AQI 資料載入錯誤: \(error)")
            }
        }
        
    }
    
    
    
}
