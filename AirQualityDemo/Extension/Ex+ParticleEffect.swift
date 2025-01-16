//
//  Ex+ParticleEmitterView.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/16.
//

import UIKit

extension CAEmitterLayer {
    func setupDefaultParticleEffect(in bounds: CGRect) {
        frame = bounds
        emitterPosition = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        emitterShape = .circle
        emitterSize = CGSize(width: bounds.width, height: bounds.height)
        emitterMode = .surface
        
        // 創建不同的粒子
        let particleCells = [
            createParticle(color: UIColor.white.withAlphaComponent(0.4), scale: 0.08, birthRate: 4),
            createParticle(color: UIColor.white.withAlphaComponent(0.3), scale: 0.05, birthRate: 5),
            createParticle(color: UIColor.white.withAlphaComponent(0.2), scale: 0.03, birthRate: 6),
            createParticle(color: UIColor.red.withAlphaComponent(0.6), scale: 0.08, birthRate: 7),
            createParticle(color: UIColor.black.withAlphaComponent(0.9), scale: 0.1, birthRate: 8),
            createParticle(color: UIColor.blue.withAlphaComponent(0.2), scale: 0.03, birthRate: 9)
        ]
        
        emitterCells = particleCells
    }
    
    private func createParticle(color: UIColor, scale: CGFloat, birthRate: Float) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.birthRate = birthRate
        cell.lifetime = 4.0
        cell.lifetimeRange = 2.0
        
        cell.velocity = 50
        cell.velocityRange = 20
        cell.scale = scale
        cell.scaleRange = scale/3
        cell.scaleSpeed = -scale/8
        
        cell.spin = CGFloat.pi
        cell.spinRange = CGFloat.pi/2
        cell.emissionRange = CGFloat.pi * 2
        
        let size = CGSize(width: 30, height: 30)
        cell.contents = drawParticleImage(size: size)?.cgImage
        cell.color = color.cgColor
        cell.alphaSpeed = -0.2
        
        return cell
    }
    
    private func drawParticleImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let colors = [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray
        let locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors,
                                        locations: locations) else { return nil }
        
        let center = CGPoint(x: size.width/2, y: size.height/2)
        context.drawRadialGradient(gradient,
                                   startCenter: center,
                                   startRadius: 0,
                                   endCenter: center,
                                   endRadius: size.width/2,
                                   options: .drawsBeforeStartLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
