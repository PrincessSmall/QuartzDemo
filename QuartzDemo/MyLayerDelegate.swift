//
//  MyLayerDelegate.swift
//  QuartzDemo
//
//  Created by LiMin on 2021/5/28.
//

import UIKit

class MyLayerDelegate: NSObject, CALayerDelegate {
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path = UIBezierPath.init(ovalIn: rect)
        UIColor.blue.setFill()
        path.fill()
        UIGraphicsPopContext()
    }
}

