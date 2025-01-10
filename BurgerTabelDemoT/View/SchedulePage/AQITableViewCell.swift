//
//  AQITableViewCell.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2025/1/3.
//

import Foundation
import UIKit

class AQITableViewCell: UITableViewCell {
    //    private let emitterLayer = CAEmitterLayer() //粒子效果
    private let gradientLayer = CAGradientLayer()
    private let blurEffect = UIBlurEffect(style: .light)
    private let blurView: UIVisualEffectView
    
    // 我的位置
    let myLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 站點名稱
    let stationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 距離
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // AQI數值
    let aqiValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // AQI單位
    let aqiUnitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // PM10 PM
    let pmOfPM10Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // PM10 10
    let tenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 6, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // PM10 數值
    let pm10ValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // PM2.5 PM
    let pmOfPM25Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // PM2.5 2.5
    let twoFiveLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 6, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // PM2.5 數值
    let pm25ValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        blurView = UIVisualEffectView(effect: blurEffect)
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
        
        //        setupEmitter() //粒子動畫
        //        setupColorChange()
       
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
            pm25ValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
            
            //            // 監測時間
            //            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            //            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    //    private func setupEmitter() {
    //        emitterLayer.frame = bounds
    //            emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    //            emitterLayer.emitterShape = .circle
    //            emitterLayer.emitterSize = CGSize(width: bounds.width, height: bounds.height)
    //            emitterLayer.emitterMode = .surface
    //
    //            // 創建更多不同的粒子
    //            let particleCell1 = createParticle(color: UIColor.white.withAlphaComponent(0.4), scale: 0.08, birthRate: 4)
    //            let particleCell2 = createParticle(color: UIColor.white.withAlphaComponent(0.3), scale: 0.05, birthRate: 5)
    //            let particleCell3 = createParticle(color: UIColor.white.withAlphaComponent(0.2), scale: 0.03, birthRate: 6)
    //        let particleCell4 = createParticle(color: UIColor.red.withAlphaComponent(0.6), scale: 0.08, birthRate: 7)
    //        let particleCell5 = createParticle(color: UIColor.black.withAlphaComponent(0.9), scale: 0.1, birthRate: 8)
    //        let particleCell6 = createParticle(color: UIColor.blue.withAlphaComponent(0.2), scale: 0.03, birthRate: 9)
    //
    //            emitterLayer.emitterCells = [particleCell1, particleCell2, particleCell3,
    //                                         particleCell4, particleCell5, particleCell6]
    //
    //            // 將 emitterLayer 插入到最底層
    //            contentView.layer.insertSublayer(emitterLayer, at: 0)
    //        }
    
//    func setupColorChange() {
//        gradientLayer.removeFromSuperlayer()  // 先移除舊的
//        
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [
//            //            UIColor(hex: 0x7BEFBB).cgColor,          // 實色
//            //            UIColor(hex: 0x7BEFBB).withAlphaComponent(0.5).cgColor  // 半透明
//            UIColor.red.cgColor,  // 使用完全不同的顏色來測試
//            UIColor.blue.cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        gradientLayer.cornerRadius = 20
//        
//        // 添加動畫
//        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
//        gradientChangeAnimation.fromValue = gradientLayer.colors
//        gradientChangeAnimation.toValue = [
//            UIColor(hex: 0x7BEFBB).withAlphaComponent(0.5).cgColor,
//            UIColor(hex: 0x7BEFBB).cgColor
//        ]
//        gradientChangeAnimation.duration = 2.0
//        gradientChangeAnimation.autoreverses = true
//        gradientChangeAnimation.repeatCount = .infinity
//        
//        gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
//        
//        // 確保在最底層插入漸層
//        contentView.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        // 確保圓角效果
        gradientLayer.cornerRadius = 20
        gradientLayer.masksToBounds = true
       
        //粒子效果
        //                emitterLayer.frame = bounds
        //                emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
//    private func createParticle(color: UIColor, scale: CGFloat, birthRate: Float) -> CAEmitterCell {
//        let cell = CAEmitterCell()
//        
//        // 增加粒子的產生率和持續時間
//        cell.birthRate = birthRate
//        cell.lifetime = 4.0
//        cell.lifetimeRange = 2.0
//        
//        // 調整運動參數
//        cell.velocity = 50
//        cell.velocityRange = 20
//        cell.scale = scale
//        cell.scaleRange = scale/3
//        cell.scaleSpeed = -scale/8
//        
//        // 增加旋轉效果
//        cell.spin = CGFloat.pi
//        cell.spinRange = CGFloat.pi/2
//        cell.emissionRange = CGFloat.pi * 2
//        
//        // 調整粒子外觀
//        let size = CGSize(width: 30, height: 30)
//        cell.contents = drawParticleImage(size: size)?.cgImage
//        cell.color = color.cgColor
//        cell.alphaSpeed = -0.2
//        
//        return cell
//    }
    
//    private func drawParticleImage(size: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        
//        // 繪製圓形漸變
//        let colors = [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray
//        let locations: [CGFloat] = [0.0, 1.0]
//        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
//                                        colors: colors,
//                                        locations: locations) else { return nil }
//        
//        let center = CGPoint(x: size.width/2, y: size.height/2)
//        context.drawRadialGradient(gradient,
//                                   startCenter: center,
//                                   startRadius: 0,
//                                   endCenter: center,
//                                   endRadius: size.width/2,
//                                   options: .drawsBeforeStartLocation)
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradientLayer.removeFromSuperlayer()
        //            setupColorChange()
        
        //莉子動畫
        //        emitterLayer.removeFromSuperlayer()
        //        setupEmitter()
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
    func configure(stationName: String, distance: Double, aqi: String, date: String, pm10: String, pm25: String) {
        myLocationLabel.text = "我的位置"
        stationNameLabel.text = "\(stationName)測站"
        distanceLabel.text = "距離\(Int(distance/1000))公里"
        
        // 根據 AQI 數值設置背景和狀態
        if let aqiInt = Int(aqi) {
            setupAnimatedBackground(aqiValue: aqiInt)
        } else {
            print("無法將 AQI 值 '\(aqi)' 轉換為 Int")
        }
        
        aqiValueLabel.text = "\(aqi)"
        aqiUnitLabel.text = "( AQI )"
        
        pmOfPM10Label.text = "PM"
        tenLabel.text = "10"
        pm10ValueLabel.text = "\(pm10)"
        
        pmOfPM25Label.text = "PM"
        twoFiveLabel.text = "2.5"
        pm25ValueLabel.text = "\(pm25)"
        
        //        // 重新設置粒子效果
        //            emitterLayer.removeFromSuperlayer()
        //            setupEmitter()
        //        dateLabel.text = date
        
        // 重新設置漸變動畫
        //            setupColorChange()
    }
}

