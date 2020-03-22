//
//  Emitterable.swift
//  HHYParticleAnimation
//
//  Created by 华惠友 on 2020/3/20.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

protocol Emitter {
    
}

extension Emitter where Self: UIViewController {
    func startEmitter(_ point : CGPoint) {
        // 1.创建发射器
        let emitter = CAEmitterLayer()
        
        // 2.设置发射器的位置
        emitter.emitterPosition = point
        
        // 3.开启三维效果
        emitter.preservesDepth = true
        
        // 4.创建粒子,并设置粒子相关的属性
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 4.1.创建粒子
            let cell = CAEmitterCell()
            
            // 4.2.设置粒子的速度
            cell.velocity = 150
            // 粒子速度范围 50 - 250
            cell.velocityRange = 100
            
            // 4.3.设置粒子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 4.4.设置粒子方向
            cell.emissionLongitude = CGFloat(-(Double.pi / 2)) // 往上
            cell.emissionRange = CGFloat(Double.pi / 12)
            
            // 4.5.设置粒子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 2
            
            // 4.6.设置粒子每秒弹出的个数
            cell.birthRate = 3
            
            // 4.6.设置粒子旋转
            cell.spin = CGFloat(CGFloat.pi / 2)
            cell.spinRange = CGFloat(CGFloat.pi / 4)
            
            // 4.8.设置粒子的展示图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            cells.append(cell)
        }
        
        // 5.将粒子设置到发射器中
        emitter.emitterCells = cells
        
        view.layer.addSublayer(emitter)
    }
    
    func stopEmitter() {
        /**
        for layer in view.layer.sublayers! {
            if layer.isKind(of: CAEmitterLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
         */
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self) }).first?.removeFromSuperlayer()
    }
}
