//
//  Ex+UIColor.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/3.
//

import Foundation
import UIKit
    
extension UIColor {
    enum Weather {
        // MARK: - AQI Colors
        enum AQI {
            /// AQI: 0-50 良好
            static let good = UIColor(r: 0, g: 153, b: 102)
            
            /// AQI: 51-100 普通
            static let moderate = UIColor(r: 255, g: 222, b: 51)
            
            /// AQI: 101-150 對敏感族群不健康
            static let unhealthyForSensitive = UIColor(r: 255, g: 153, b: 51)
            
            /// AQI: 151-200 對所有族群不健康
            static let unhealthy = UIColor(r: 204, g: 0, b: 0)
            
            /// AQI: 201-300 非常不健康
            static let veryUnhealthy = UIColor(r: 102, g: 0, b: 153)
            
            /// AQI: 301-400 危害
            static let hazardous1 = UIColor(r: 126, g: 0, b: 35)
            
            /// AQI: 401-500 危害
            static let hazardous2 = UIColor(r: 153, g: 0, b: 76)
            
            /// 無資料
            static let noData = UIColor.gray
            
            // Helper method to get color based on AQI value
            static func color(for value: Int) -> UIColor {
                switch value {
                case 0...50: return good
                case 51...100: return moderate
                case 101...150: return unhealthyForSensitive
                case 151...200: return unhealthy
                case 201...300: return veryUnhealthy
                case 301...400: return hazardous1
                case 401...500: return hazardous2
                default: return noData
                }
            }
        }
        
        // MARK: - Theme Colors
        enum Theme {
            static let background = UIColor.white
            static let text = UIColor.black
            static let secondaryText = UIColor.gray
            // 可以添加更多主題顏色...
        }
        
        // MARK: - Tab Bar Colors
        enum TabBar {
            static let background = Theme.background
            static let selectedTint = UIColor.black
            static let unselectedTint = UIColor.gray
        }
    }
}

// MARK: - UIColor Convenience Initializers
extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: a
        )
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            r: (hex >> 16) & 0xFF,
            g: (hex >> 8) & 0xFF,
            b: hex & 0xFF,
            a: alpha
        )
    }
}
