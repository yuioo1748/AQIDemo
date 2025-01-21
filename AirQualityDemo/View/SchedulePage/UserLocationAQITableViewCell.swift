//
//  UserLactionAQITableViewCell.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/3.
//

import Foundation
import UIKit

class UserLocationAQITableViewCell: UITableViewCell {
    //    private let emitterLayer = CAEmitterLayer() //粒子效果
    private let gradientLayer = CAGradientLayer()
    
    // 我的位置
    let myLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // 站點名稱
    let stationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyShadow(opacity: 0.3)
        return label
    }()
    
    // 距離
    let distanceLabel: UILabel = {
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
    
    //    // 監測時間
    //    let dateLabel: UILabel = {
    //        let label = UILabel()
    //        label.font = .systemFont(ofSize: 15)
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
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
                
        contentView.addSubview(myLocationLabel)
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(aqiValueLabel)
        contentView.addSubview(aqiUnitLabel)
        //        contentView.addSubview(dateLabel)
        contentView.addSubview(pmOfPM10Label)
        contentView.addSubview(tenLabel)
        contentView.addSubview(pm10ValueLabel)
        contentView.addSubview(pmOfPM25Label)
        contentView.addSubview(twoFiveLabel)
        contentView.addSubview(pm25ValueLabel)
        
        NSLayoutConstraint.activate([
            
            myLocationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            myLocationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            // 站點名稱
            stationNameLabel.topAnchor.constraint(equalTo: myLocationLabel.bottomAnchor, constant: 5),
            stationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            // 距離
            distanceLabel.topAnchor.constraint(equalTo: myLocationLabel.bottomAnchor, constant: 5),
            distanceLabel.leadingAnchor.constraint(equalTo: stationNameLabel.trailingAnchor, constant: 5),
            
            
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
            
            //            // 監測時間
            //            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            //            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
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
                   distance: Double,
                   aqi: String,
                   date: String,
                   pm10: String,
                   pm25: String,
                   recordType: RecordType) {
        
        myLocationLabel.text = "我的位置"
        stationNameLabel.text = "\(stationName)測站"
        distanceLabel.text = "距離\(Int(distance/1000))公里"
        
        aqiUnitLabel.text = "( AQI )"
        
        pmOfPM10Label.text = "PM"
        tenLabel.text = "10"
        
        pmOfPM25Label.text = "PM"
        twoFiveLabel.text = "2.5"
        
        switch recordType {
        case .record(let record):
            
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

