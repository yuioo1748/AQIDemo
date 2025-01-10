//
//  AirInfoTabelViewCell.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2025/1/10.
//

import Foundation

import UIKit

class AirInfoTabelViewCell: UITableViewCell {
    
    
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
        
        // 確保背景是透明的
        contentView.backgroundColor = .clear
    }
    
}
