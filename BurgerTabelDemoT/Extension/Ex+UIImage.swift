//
//  Ex+UIImage.swift
//  BurgerTabelDemoT
//
//  Created by AndyHsieh on 2024/12/30.
//

import Foundation
import UIKit

//修改圖片
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
