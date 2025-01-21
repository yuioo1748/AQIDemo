//
//  DateUtils.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/21.
//

import Foundation

/// 日期與時間格式化工具
class DateUtils {
    
    /// 將日期字串轉換為時間格式 (HH:mm:ss)
    /// - Parameter dateString: 原始日期字串 (格式：yyyy/MM/dd HH:mm:ss)
    /// - Returns: 轉換後的時間字串 (格式：HH:mm:ss)，或 nil 如果轉換失敗
    static func convertToTime(from dateString: String) -> String? {
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
    
    /// 將日期字串轉換為日期格式 (yyyy/MM/dd)
    /// - Parameter dateString: 原始日期字串 (格式：yyyy/MM/dd HH:mm:ss)
    /// - Returns: 轉換後的日期字串 (格式：yyyy/MM/dd)，或 nil 如果轉換失敗
    static func convertToDate(from dateString: String) -> String? {
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
