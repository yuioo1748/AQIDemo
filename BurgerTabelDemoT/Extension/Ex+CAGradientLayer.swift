//
//  Ex+CAGradientLayer.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2025/1/10.
//

import UIKit

// 漸層動畫配置協議
protocol GradientAnimationConfigurable {
    /// 提供漸層動畫的顏色
    func gradientAnimationColors() -> [CGColor]
    
    /// 自定義動畫持續時間，預設為5.0秒
    func gradientAnimationDuration() -> CFTimeInterval
    
    /// 是否啟用不透明度動畫，預設為true
    func shouldAnimateOpacity() -> Bool
}

// 擴展協議，加入 AQI 相關的顏色動態生成方法
protocol AQIGradientAnimationConfigurable: GradientAnimationConfigurable {
    /// 根據 AQI 數值獲取漸層顏色
    /// - Parameter aqiValue: 空氣品質指數
    /// - Returns: 對應的漸層顏色數組
    func gradientColorsForAQI(aqiValue: Int) -> [CGColor]
    
    /// 獲取 AQI 狀態描述
    /// - Parameter aqiValue: 空氣品質指數
    /// - Returns: 對應的狀態文字
    func aqiStatusDescription(for aqiValue: Int) -> String
}

// 提供預設實現
extension GradientAnimationConfigurable {
    func gradientAnimationDuration() -> CFTimeInterval {
        return 5.0
    }
    
    func shouldAnimateOpacity() -> Bool {
        return true
    }
}

// CAGradientLayer 擴展，提供動畫方法
extension CAGradientLayer {
    /// 應用平滑的波浪動畫
    func applyWaveAnimation(with config: GradientAnimationConfigurable) {
        // 設置初始顏色和位置
        self.colors = config.gradientAnimationColors()
        self.locations = [0.3, 0.5, 0.7]
        
        // 初始起點和終點
        self.startPoint = CGPoint(x: -0.5, y: 0)
        self.endPoint = CGPoint(x: 1.5, y: 1)
        
        // 位置動畫
        let locationAnimation = createLocationAnimation(duration: config.gradientAnimationDuration())
        
        // 起點動畫
        let startPointAnimation = createStartPointAnimation(duration: config.gradientAnimationDuration())
        
        // 終點動畫
        let endPointAnimation = createEndPointAnimation(duration: config.gradientAnimationDuration())
        
        // 組合動畫
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [
            locationAnimation,
            startPointAnimation,
            endPointAnimation
        ]
        
        // 可選的不透明度動畫
        if config.shouldAnimateOpacity() {
            let opacityAnimation = createOpacityAnimation(duration: config.gradientAnimationDuration())
            groupAnimation.animations?.append(opacityAnimation)
        }
        
        groupAnimation.duration = config.gradientAnimationDuration()
        groupAnimation.repeatCount = .infinity
        
        self.add(groupAnimation, forKey: "ultraSmoothWaveAnimation")
    }
    
    /// 創建位置動畫
    private func createLocationAnimation(duration: CFTimeInterval) -> CAKeyframeAnimation {
        let locationAnimation = CAKeyframeAnimation(keyPath: "locations")
        locationAnimation.calculationMode = .cubic
        locationAnimation.values = [
            [0.2, 0.4, 0.6],
            [0.25, 0.45, 0.65],
            [0.3, 0.5, 0.7],
            [0.35, 0.55, 0.75],
            [0.4, 0.6, 0.8],
            [0.35, 0.55, 0.75],
            [0.3, 0.5, 0.7],
            [0.25, 0.45, 0.65],
            [0.2, 0.4, 0.6]
        ]
        locationAnimation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0]
        locationAnimation.duration = duration
        locationAnimation.repeatCount = .infinity
        return locationAnimation
    }
    
    /// 創建起點動畫
    private func createStartPointAnimation(duration: CFTimeInterval) -> CAKeyframeAnimation {
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.calculationMode = .cubic
        startPointAnimation.values = [
            CGPoint(x: -0.5, y: 0),
            CGPoint(x: -0.3, y: 0.1),
            CGPoint(x: -0.1, y: 0.2),
            CGPoint(x: -0.3, y: 0.1),
            CGPoint(x: -0.5, y: 0),
            CGPoint(x: -0.7, y: -0.1),
            CGPoint(x: -0.9, y: -0.2),
            CGPoint(x: -0.7, y: -0.1),
            CGPoint(x: -0.5, y: 0)
        ]
        startPointAnimation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0]
        startPointAnimation.duration = duration
        startPointAnimation.repeatCount = .infinity
        return startPointAnimation
    }
    
    /// 創建終點動畫
    private func createEndPointAnimation(duration: CFTimeInterval) -> CAKeyframeAnimation {
        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.calculationMode = .cubic
        endPointAnimation.values = [
            CGPoint(x: 1.5, y: 1),
            CGPoint(x: 1.3, y: 0.9),
            CGPoint(x: 1.1, y: 0.8),
            CGPoint(x: 1.3, y: 0.9),
            CGPoint(x: 1.5, y: 1),
            CGPoint(x: 1.7, y: 1.1),
            CGPoint(x: 1.9, y: 1.2),
            CGPoint(x: 1.7, y: 1.1),
            CGPoint(x: 1.5, y: 1)
        ]
        endPointAnimation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0]
        endPointAnimation.duration = duration
        endPointAnimation.repeatCount = .infinity
        return endPointAnimation
    }
    
    /// 創建不透明度動畫
    private func createOpacityAnimation(duration: CFTimeInterval) -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.calculationMode = .cubic
        opacityAnimation.values = [0.7, 0.8, 1.0, 0.8, 0.7]
        opacityAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        opacityAnimation.duration = duration
        opacityAnimation.repeatCount = .infinity
        return opacityAnimation
    }
}

// 提供預設實現
extension AQIGradientAnimationConfigurable {
    /// 預設的 AQI 顏色映射
    func gradientColorsForAQI(aqiValue: Int) -> [CGColor] {
        switch aqiValue {
        case 0...50:
            // 良好：綠色系漸層
            return [
                UIColor(hex: 0x00FF00, alpha: 0.1).cgColor,
                UIColor(hex: 0x00FF00, alpha: 0.4).cgColor,
                UIColor(hex: 0x00FF00, alpha: 0.7).cgColor
            ]
        case 51...100:
            // 普通：黃色系漸層
            return [
                UIColor(hex: 0xFFFF00, alpha: 0.1).cgColor,
                UIColor(hex: 0xFFFF00, alpha: 0.4).cgColor,
                UIColor(hex: 0xFFFF00, alpha: 0.7).cgColor
            ]
        case 101...150:
            // 對敏感族群不健康：橙色系漸層
            return [
                UIColor(hex: 0xFFA500, alpha: 0.1).cgColor,
                UIColor(hex: 0xFFA500, alpha: 0.4).cgColor,
                UIColor(hex: 0xFFA500, alpha: 0.7).cgColor
            ]
        case 151...200:
            // 對所有族群不健康：紅色系漸層
            return [
                UIColor(hex: 0xFF0000, alpha: 0.1).cgColor,
                UIColor(hex: 0xFF0000, alpha: 0.4).cgColor,
                UIColor(hex: 0xFF0000, alpha: 0.7).cgColor
            ]
        case 201...300:
            // 非常不健康：紫色系漸層
            return [
                UIColor(hex: 0x800080, alpha: 0.1).cgColor,
                UIColor(hex: 0x800080, alpha: 0.4).cgColor,
                UIColor(hex: 0x800080, alpha: 0.7).cgColor
            ]
        case 301...400:
            // 危害（深色）：棕色系漸層
            return [
                UIColor(hex: 0x8B4513, alpha: 0.1).cgColor,
                UIColor(hex: 0x8B4513, alpha: 0.4).cgColor,
                UIColor(hex: 0x8B4513, alpha: 0.7).cgColor
            ]
        case 401...500:
            // 危害（深褐色）：近乎黑色漸層
            return [
                UIColor(hex: 0x2F4F4F, alpha: 0.1).cgColor,
                UIColor(hex: 0x2F4F4F, alpha: 0.4).cgColor,
                UIColor(hex: 0x2F4F4F, alpha: 0.7).cgColor
            ]
        default:
            // 無資料：灰色系漸層
            return [
                UIColor(hex: 0xCCCCCC, alpha: 0.1).cgColor,
                UIColor(hex: 0xCCCCCC, alpha: 0.4).cgColor,
                UIColor(hex: 0xCCCCCC, alpha: 0.7).cgColor
            ]
        }
    }
    
    /// 預設的 AQI 狀態描述
       func aqiStatusDescription(for aqiValue: Int) -> String {
           switch aqiValue {
           case 0...50:
               return "良好"
           case 51...100:
               return "普通"
           case 101...150:
               return "對敏感族群不健康"
           case 151...200:
               return "對所有族群不健康"
           case 201...300:
               return "非常不健康"
           case 301...400:
               return "危害"
           case 401...500:
               return "危害"
           default:
               return "無資料"
           }
       }
   }
