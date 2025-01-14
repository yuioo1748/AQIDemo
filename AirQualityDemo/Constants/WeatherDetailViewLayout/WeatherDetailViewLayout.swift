//
//  WeatherDetailViewLayout.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/9.
//

import CoreFoundation

enum WeatherDetailViewLayout {
        enum TabBar {
            static let height: CGFloat = 80
            static let buttonSize: CGFloat = 44
            static let buttonSpacing: CGFloat = 20  // 按鈕離邊緣的距離
        }
        
        enum Icons {
            static let weatherIconSize = CGSize(width: 25, height: 25)
            static let listIconSize = CGSize(width: 27, height: 18)
        }
        
        enum Spacing {
            static let cityLabelTop: CGFloat = 50
            static let aqiLabelSpacing: CGFloat = -10  // cityLabel 和 largeAqiLabel 之間的間距
            static let unitLabelLeading: CGFloat = 3   // largeAqiLabel 和 unitLabel 之間的間距
            static let unitLabelBottom: CGFloat = -24  // unitLabel 底部對齊
            static let smallLabelSpacing: CGFloat = -35 // smallAqiLabel 和中心的距離
        }
        
        enum ScrollView {
            static let maxOffset: CGFloat = 200       // 滾動效果的最大偏移量
            static let contentHeight: CGFloat = 1000   // ScrollView 內容高度
            static let safeAreaMinY: CGFloat = 0      // 最小 Y 值（會和 safeArea 相加）
            static let safeAreaMaxY: CGFloat = 100    // 最大 Y 值（會和 safeArea 相加）
        }
        
        enum Font {
            static let cityLabelSize: CGFloat = 35
            static let largeAqiLabelSize: CGFloat = 96
            static let smallAqiLabelSize: CGFloat = 20
            static let aqiUnitLabelSize: CGFloat = 16
            static let smallAqiUnitLabelSize: CGFloat = 10
            static let aqiStatusLabelSize: CGFloat = 20
        }
    }
