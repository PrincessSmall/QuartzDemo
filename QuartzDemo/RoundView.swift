//
//  RoundView.swift
//  QuartzDemo
//
//  Created by LiMin on 2021/5/27.
//

import UIKit

class RoundView: UIView {
    var layerdelegate: MyLayerDelegate = MyLayerDelegate.init()
    var myLayer:CALayer = CALayer.init()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func initUI() {
        backgroundColor = .white
//        setupLayerDelegate()
        testCoreGraphics()
    }
    
    func testUIkit() {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        imageView.backgroundColor = UIColor.white
        self.addSubview(imageView)
        guard let image = testCongraphocsWithUIKit() else { return }
        imageView.image = image
    }
    
    func testCoreGraphics() {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        imageView.backgroundColor = UIColor.white
        self.addSubview(imageView)
        guard let image = testUIGraphicsWithCoreGraphics() else { return }
        imageView.image = image
    }

    // 在UIView的子类方法drawRect中
    // 第一种绘图形式：在UIView的子类方法drawRect：中绘制一个蓝色圆，使用UIKit在Cocoa为我们提供的当前上下文中完成绘图任务。
//    override func draw(_ rect: CGRect) {
//        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//        let cornerPath = UIBezierPath.init(ovalIn: rect)
//        UIColor.blue.setFill()
//        cornerPath.fill()
//    }
    
    // 第二种绘图形式：使用Core Graphics实现绘制蓝色圆。
//    override func draw(_ rect: CGRect) {
//        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//        guard let ctx = UIGraphicsGetCurrentContext() else { return } // 使用Core Graphics之前需要指定一个用于绘图的图形上下文（CGContextRef）,使用此函数用来获取当前的图形上下文
//        ctx.addEllipse(in: rect)
//        ctx.setFillColor(UIColor.blue.cgColor)
//        ctx.fillPath()
//    }
    
    // 在drawLayer: inContext:中绘制内容
    // 第三种绘图方式：在UIView的子类的drawLayer: inContext:方法中实现绘图任务。
    /*
     1. drawLayer: inContext:是一个绘制图层内容的代理方法
     2. 为了能够调用这个方法，我们需要设定图层的代理对象
     3. 但要注意，不应该将UIView对象设置为显示层的委托对象，这是因为UIView对象已经是隐式层的代理对象，再将它设置为另一个层的委托对象就会出问题。
     4. 轻量级的做法是：编写负责绘图形的代理类。完成代理实现
     5. 在UIView子类中，设置代理，生成CALayer子类，作为委托对象，并调用setNeedsDisplay方法，触发drawLayer: inContext:方法。
     6.因为图层的代理是assign内存管理策略，那么这里就不能以局部变量的形式创建MyLayerDelegate实例对象赋值给图层代理。这里选择在MyView.m中增加一个实例变量，因为实例变量默认是strong:
     */
//    func setupLayerDelegate() {
//        myLayer.delegate = layerdelegate
//        self.layer.addSublayer(myLayer)
//        self.setNeedsDisplay() // 调用此方法，drawLayer: inContext:方法才会被调用。
//    }
    
    
    // 最后，演示UIGraphicsBeginImageContextWithOptions的用法，并从上下文中生成一个UIImage对象。生成UIImage对象的代码可以在任何地方被使用，它没有上述绘图方法那样的限制。
    // 1. 使用UIKit实现
    func testCongraphocsWithUIKit() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize.init(width: 100, height: 100))
        let p = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        let blueColor = UIColor.blue
        blueColor.setFill()
        p.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func testUIGraphicsWithCoreGraphics() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), true, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        let rect = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        ctx.addEllipse(in: rect)
        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.fillPath()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
        UIGraphicsEndImageContext()
        return image
    }
}
/* Core Graphics上下文属性设置
 当你在图形上下文中绘图时，当前图形上下文的相关属性将决定绘图的行为与外观。因此，绘图的一般过程是先设定好图形上下文参数，然后绘图。比如说，要画一根红线，接着画一根蓝线。那么，
    首先：需要将上下文的线条颜色属性设定为红色，然后画红线；
    接着：设置上下文的线条颜色属性为蓝色，再画出蓝线。
 表面上看，红线和蓝线是分开的，但事实上，在你画每一条线时，线条颜色却是整个上下文的属性。无论你用的是UIKit方法还是Core Graphics函数。
 
 因为图形上下文在每一时刻都有一个确定的状态，该状态概括了图形上下文所有属性的设置。为了便于操作这些状态，图形上下文提供了一个用来持有状态的栈。调用CGContextSaveGState函数，上下文会将完整的当前状态压入栈顶；调用CGContextRestoreGState函数，上下文查找处在栈顶的状态，并设置当前上下文状态为栈顶状态。

 因此一般绘图模式是：在绘图之前调用CGContextSaveGState函数保存当前状态，接着根据需要设置某些上下文状态，然后绘图，最后调用CGContextRestoreGState函数将当前状态恢复到绘图之前的状态。要注意的是，CGContextSaveGState函数和CGContextRestoreGState函数必须成对出现，否则绘图很可能出现意想不到的错误，这里有一个简单的做法避免这种情况。代码如下：
 */

/*
 但你不需要在每次修改上下文状态之前都这样做，因为你对某一上下文属性的设置并不一定会和之前的属性设置或其他的属性设置产生冲突。你完全可以在不调用保存和恢复函数的情况下先设置线条颜色为红色，然后再设置为蓝色。但在一定情况下，你希望你对状态的设置是可撤销的，我将在接下来讨论这样的情况。

 许多的属性组成了一个图形上下文状态，这些属性设置决定了在你绘图时图形的外观和行为。下面我列出了一些属性和对应修改属性的函数；虽然这些函数是关于Core Graphics的，但记住，实际上UIKit同样是调用这些函数操纵上下文状态。
 */
extension RoundView {
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        ctx?.restoreGState()
    }
}
