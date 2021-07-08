//
//  ArrowView.swift
//  QuartzDemo
//
//  Created by LiMin on 2021/7/7.
//

import UIKit

class ArrowView: UIView {

    
}

extension ArrowView {
    /* 裁剪
     
     */
//    override func draw(_ rect: CGRect) {
//        let ctx = UIGraphicsGetCurrentContext()
//        // 在上下文裁剪区域中挖一个三角形状的孔
//        ctx?.move(to: CGPoint(x: 90, y: 100))
//        ctx?.addLine(to: CGPoint(x: 110, y: 100))
//        ctx?.addLine(to: CGPoint(x: 100, y: 90))
//        ctx?.closePath()
//        ctx?.addRect(ctx!.boundingBoxOfClipPath)
//        // 使用奇偶规则，裁剪区域为矩形减去三角形区域
//        ctx?.clip(using: CGPathFillRule.evenOdd)
//        // 绘制垂线
//        ctx?.move(to: CGPoint(x: 100, y: 100))
//        ctx?.addLine(to: CGPoint(x: 100, y: 19))
//        ctx?.setLineWidth(20)
//        ctx?.strokePath()
//        // 画红色箭头
//        UIColor.red.set()
//        ctx?.move(to: CGPoint(x: 80, y: 25))
//        ctx?.addLine(to: CGPoint(x: 100, y: 0))
//        ctx?.addLine(to: CGPoint(x: 120, y: 25))
//        ctx?.fillPath()
//    }
    
    /* 渐变
     渐变可以很简单也可以很复杂。一个简单的渐变（接下来要讨论的）由一端点的颜色与另一端点的颜色决定，如果在中间点加入颜色（可选），那么渐变会在上下文的两个点之间线性的绘制或在上下文的两个圆之间放射状的绘制。不能使用渐变作为路径的填充色，但可使用裁剪限制对路径形状的渐变。
     */
//    override func draw(_ rect: CGRect) {
//    let ctx = UIGraphicsGetCurrentContext()
//    ctx?.saveGState()
//    // 在上下文裁剪区域中挖一个三角形状的孔
//    ctx?.move(to: CGPoint(x: 90, y: 100))
//    ctx?.addLine(to: CGPoint(x: 110, y: 100))
//    ctx?.addLine(to: CGPoint(x: 100, y: 90))
//    ctx?.closePath()
//    ctx?.addRect(ctx!.boundingBoxOfClipPath)
//    ctx?.clip(using: CGPathFillRule.evenOdd)
//    // 绘制垂线
//    ctx?.move(to: CGPoint(x: 100, y: 100))
//    ctx?.addLine(to: CGPoint(x: 100, y: 19))
//    ctx?.setLineWidth(20)
//    // 使用路径的描边版本替换图形上下文的路径
//    ctx?.replacePathWithStrokedPath()
//    // 对路径的描边版本实施裁剪
//    ctx?.clip()
//    // 绘制渐变
//    let locs: [CGFloat] = [0.0, 0.5, 1.0]
//    let colors: [CGFloat] = [0.3, 0.3,0.3, 0.8, 0, 0, 1.0,0.3, 0.3, 0.3, 0.8]
//    let sp = CGColorSpaceCreateDeviceGray()
//    let grad = CGGradient.init(colorSpace: sp, colorComponents: colors, locations: locs, count: 3)!
//    ctx?.drawLinearGradient(grad, start: CGPoint(x: 89, y: 0), end: CGPoint(x: 111, y: 0), options: CGGradientDrawingOptions.init(rawValue: 0))
//    ctx?.restoreGState()
//    // 画红色箭头
//    UIColor.red.set()
//    ctx?.move(to: CGPoint(x: 80, y: 25))
//    ctx?.addLine(to: CGPoint(x: 100, y: 0))
//    ctx?.addLine(to: CGPoint(x: 120, y: 25))
//    ctx?.fillPath()
//    }
    
    /* 图形上下文变换
     我将绕箭头杆子尾部旋转多个角度重复绘制箭头，并把对箭头的绘图封装为UIImage对象。接着我们简单重复绘制UIImage对象。
     */
    override func draw(_ rect: CGRect) {
        let ctxSize = CGSize(width: 40, height: 100)
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        var ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.move(to: CGPoint(x: 90 - 80, y: 100))
        ctx?.addLine(to: CGPoint(x: 110 - 80, y: 100))
        ctx?.addLine(to: CGPoint(x: 100 - 80, y: 90))
        ctx?.closePath()
        ctx?.addRect(ctx!.boundingBoxOfClipPath)
        ctx?.clip(using: CGPathFillRule.evenOdd)
        ctx?.move(to: CGPoint(x: 100 - 80, y: 100))
        ctx?.addLine(to: CGPoint(x: 100 - 80, y: 19))
        ctx?.setLineWidth(20)
        ctx?.replacePathWithStrokedPath()
        ctx?.clip()
        let locs: [CGFloat] = [0.0, 0.5, 1.0]
        let colors: [CGFloat] = [0.3, 0.3,0.3, 0.8, 0, 0, 1.0,0.3, 0.3, 0.3, 0.8]
        let sp = CGColorSpaceCreateDeviceGray()
        let grad = CGGradient.init(colorSpace: sp, colorComponents: colors, locations: locs, count: 3)!
        ctx?.drawLinearGradient(grad, start: CGPoint(x: 89 - 80, y: 0), end: CGPoint(x: 111 - 80, y: 0), options: CGGradientDrawingOptions.init(rawValue: 0))
        ctx?.restoreGState()
        UIColor.red.set()
        ctx?.move(to: CGPoint(x: 80 - 80, y: 25))
        ctx?.addLine(to: CGPoint(x: 100 - 80, y: 0))
        ctx?.addLine(to: CGPoint(x: 120 - 80, y: 25))
        ctx?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ctx = UIGraphicsGetCurrentContext()
        image?.draw(at: CGPoint(x: 0, y: 0))
        for _ in 0..<3 {
            // 先是应用了一个平移变换，为的是映射原点到你真正想绕其旋转的点。
            ctx?.translateBy(x: 20, y: 100)
            ctx?.rotate(by: CGFloat(30 * .pi/180.0))
            // 在旋转之后，为了算出你在哪里绘图，你可能需要做一次逆向平移变换。
            ctx?.translateBy(x: -20, y: -100)
            image?.draw(at: CGPoint(x: 0, y: 0))
        }
    }
    
}
