//
//  MainNavBarController.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/2.
//

import Foundation
import UIKit

class MainNavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainNavBarController()
    }
    
    private func setupMainNavBarController() {
        let barAppearance = UINavigationBarAppearance()
        
        if #available(iOS 15.0, *) {
            
            barAppearance.backgroundColor = .white
            barAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,  // 設定標題顏色
                .font: UIFont.systemFont(ofSize: 17, weight: .medium)  // 可選：設定字體
            ]
            // 全局設定，會影響整個 App 中所有的 navigation bar
            UINavigationBar.appearance().standardAppearance = barAppearance // 導航欄的標準外觀
            UINavigationBar.appearance().scrollEdgeAppearance = barAppearance //當滾動視圖到頂部時的外觀 （外觀向
            
        } else if #available(iOS 14.0, *) {
            
            barAppearance.backgroundColor = .white
            barAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 17, weight: .medium)
            ]
            
            // 全局設定，會影響整個 App 中所有的 navigation bar
            UINavigationBar.appearance().standardAppearance = barAppearance
            
        } else { //處理其他版本
            
        }
        navigationBar.isTranslucent = false //設定導航欄為不透明（佈局向
        
    }
    
    
}
