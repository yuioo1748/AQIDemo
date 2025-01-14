//
//  AirInfoTabelViewCell.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/10.
//

import Foundation

import UIKit

class AirInfoTabelViewCell: UITableViewCell {
    // 主標籤
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 單位標籤
    private let airValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 單位標籤
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        selectionStyle = .none
        
        // 添加子視圖
        contentView.addSubview(mainLabel)
        contentView.addSubview(airValueLabel)
        contentView.addSubview(unitLabel)
        
        // 設置約束
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            airValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
            airValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
//            unitLabel.leadingAnchor.constraint(equalTo: airValueLabel.trailingAnchor, constant: 20),
            unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            unitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
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
    
    // 配置 Cell 的方法
    func configure(mainText: NSAttributedString, airValueText: String, unitText: String) {
        mainLabel.attributedText = mainText
        airValueLabel.text = airValueText
        unitLabel.text = unitText
    }
}
