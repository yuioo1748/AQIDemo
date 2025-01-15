//
//  Ex+UILabel.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/15.
//

import Foundation
import UIKit

extension UILabel {
    func applyShadow(color: UIColor = .gray, opacity: Float = 0.5, offset: CGSize = CGSize(width: 2, height: 2), radius: CGFloat = 3) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
