//
//  FavoriteLocationAQITableViewCell.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/20.
//

import Foundation
import UIKit

class FavoriteLocationAQITableViewCell: UITableViewCell {
    //    private let emitterLayer = CAEmitterLayer() //粒子效果
    private let gradientLayer = CAGradientLayer()
    private let dateFormatter = DateFormatter()
    
    // 我的位置
    let stationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // 更新時間
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // AQI數值
    let aqiValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // AQI單位
    let aqiUnitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // PM10 PM
    let pmOfPM10Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // PM10 10
    let tenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 6, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // PM10 數值
    let pm10ValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // PM2.5 PM
    let pmOfPM25Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // PM2.5 2.5
    let twoFiveLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 6, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // PM2.5 數值
    let pm25ValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        // 設定 cell 背景顏色
        backgroundColor = .clear
        //        contentView.backgroundColor = UIColor(hex: 0x7BEFBB)
        contentView.backgroundColor = .clear  // 改為透明
        
        // 可以添加圓角
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(updateTimeLabel)
        contentView.addSubview(aqiValueLabel)
        contentView.addSubview(aqiUnitLabel)
        contentView.addSubview(pmOfPM10Label)
        contentView.addSubview(tenLabel)
        contentView.addSubview(pm10ValueLabel)
        contentView.addSubview(pmOfPM25Label)
        contentView.addSubview(twoFiveLabel)
        contentView.addSubview(pm25ValueLabel)
        
        NSLayoutConstraint.activate([
            
            stationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            // 站點名稱
            updateTimeLabel.topAnchor.constraint(equalTo: stationNameLabel.bottomAnchor, constant: 5),
            updateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            // AQI數值
            aqiUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            aqiUnitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            
            aqiValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            aqiValueLabel.trailingAnchor.constraint(equalTo: aqiUnitLabel.leadingAnchor, constant: 0),
            
            //pm10
            pmOfPM10Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            pmOfPM10Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -110),
            
            tenLabel.leadingAnchor.constraint(equalTo: pmOfPM10Label.trailingAnchor, constant: 0),
            tenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            pm10ValueLabel.leadingAnchor.constraint(equalTo: tenLabel.trailingAnchor, constant: 3),
            pm10ValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            
            //pm25
            pmOfPM25Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            pmOfPM25Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            
            twoFiveLabel.leadingAnchor.constraint(equalTo: pmOfPM25Label.trailingAnchor, constant: 0),
            twoFiveLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            pm25ValueLabel.leadingAnchor.constraint(equalTo: twoFiveLabel.trailingAnchor, constant: 3),
            pm25ValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            pm25ValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
        
        // 設置粒子效果
        //        emitterLayer.setupDefaultParticleEffect(in: bounds)
        //        contentView.layer.insertSublayer(emitterLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        // 確保圓角效果
        gradientLayer.cornerRadius = 20
        gradientLayer.masksToBounds = true
        
        // 設定內容的間距
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        
        // 尋找 UISwipeActionPullView
        if let swipeContainer = self.superview, NSStringFromClass(swipeContainer.classForCoder) == "_UITableViewCellSwipeContainerView" {
            for subview in swipeContainer.subviews {
                if NSStringFromClass(subview.classForCoder) == "UISwipeActionPullView" {
                    subview.layer.cornerRadius = 12
                    subview.clipsToBounds = true
                }
            }
        }
        //粒子效果
        //        emitterLayer.frame = bounds
        //        emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradientLayer.removeFromSuperlayer()
        
        //粒子動畫
        //        emitterLayer.removeFromSuperlayer()
        //        emitterLayer.setupDefaultParticleEffect(in: bounds)
        //        contentView.layer.insertSublayer(emitterLayer, at: 0)
    }
    
    private func setupAnimatedBackground(aqiValue: Int) {
        // 創建一個遵循協議的配置
        struct AQIGradientConfig: AQIGradientAnimationConfigurable {
            let aqiValue: Int
            
            func gradientAnimationColors() -> [CGColor] {
                // 直接使用根據 AQI 數值生成的漸層顏色
                return gradientColorsForAQI(aqiValue: aqiValue)
            }
        }
        
        // 應用動畫
        let config = AQIGradientConfig(aqiValue: aqiValue)
        gradientLayer.applyWaveAnimation(with: config)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // 配置 Cell 內容的方法
    func configure(stationName: String,
                   updateTime: String,
                   aqi: String,
                   pm10: String,
                   pm25: String,
                   recordType: RecordType) {
        
        stationNameLabel.text = "\(stationName)測站"
        
        aqiUnitLabel.text = "( AQI )"
        
        pmOfPM10Label.text = "PM"
        tenLabel.text = "10"
        
        pmOfPM25Label.text = "PM"
        twoFiveLabel.text = "2.5"
        
        switch recordType {
        case .record(let record):
            
            // 使用 convertToDate 方法來轉換 updateTime (如果需要的話)
            if let dateString = DateUtils.convertToDate(from: updateTime) {
                print("日期部分：\(dateString)")
            } else {
                updateTimeLabel.text = "更新時間：\(updateTime)"
            }
            
            // 根據 AQI 數值設置背景和狀態
            if let aqiInt = Int(record.aqi) {
                setupAnimatedBackground(aqiValue: aqiInt)
            } else {
                print("無法將 AQI 值 '\(aqi)' 轉換為 Int")
            }
            
            aqiValueLabel.text = record.aqi
            pm10ValueLabel.text = record.pm10SubIndex
            pm25ValueLabel.text = record.pm25SubIndex
            
        case .detailedRecord(let detailedRecord):
            
            // 使用 convertToTime 方法來轉換 updateTime
            if let timeString = DateUtils.convertToTime(from: updateTime) {
                updateTimeLabel.text = "更新時間：\(timeString)"
            } else {
                updateTimeLabel.text = "更新時間：\(updateTime)"
            }
            
            // 根據 AQI 數值設置背景和狀態
            if let aqiInt = Int(detailedRecord.aqi) {
                setupAnimatedBackground(aqiValue: aqiInt)
            } else {
                print("無法將 AQI 值 '\(aqi)' 轉換為 Int")
            }
            
            aqiValueLabel.text = detailedRecord.aqi
            pm10ValueLabel.text = detailedRecord.pm10
            pm25ValueLabel.text = detailedRecord.pm25
            
        }
        
        // 重新設置粒子效果
        //        emitterLayer.removeFromSuperlayer()
        //        emitterLayer.setupDefaultParticleEffect(in: bounds)
        //        contentView.layer.insertSublayer(emitterLayer, at: 0)
        
        //                dateLabel.text = date
        
    }
}

extension FavoriteLocationAQITableViewCell {
    
    //updateTime只取時間
    func convertToTime(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        // 嘗試將日期字串轉換為 Date 物件
        if let date = dateFormatter.date(from: dateString) {
            // 設定顯示時間的格式
            dateFormatter.dateFormat = "HH:mm:ss"
            // 返回格式化後的時間字串
            return dateFormatter.string(from: date)
        }
        // 如果轉換失敗，返回 nil
        return nil
    }
    
    //updateTime只取日期
    func convertToDate(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        // 嘗試將日期字串轉換為 Date 物件
        if let date = dateFormatter.date(from: dateString) {
            // 設定顯示日期的格式
            dateFormatter.dateFormat = "yyyy/MM/dd"
            // 返回格式化後的日期字串
            return dateFormatter.string(from: date)
        }
        // 如果轉換失敗，返回 nil
        return nil
    }
    
}
