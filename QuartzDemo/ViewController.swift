//
//  ViewController.swift
//  QuartzDemo
//
//  Created by LiMin on 2021/5/27.
//

import UIKit
/*
 Core Graphics API所有的操作都在上下文中进行。所以在绘图之前需要获取该上下文并传入执行渲染的函数内。如果你正在渲染一副在内存中的图片，此时就需要传入图片所属的上下文。
 获得一个图形上下文是我们完成绘图任务的第一步，你可以将图形上下文理解为一块画布。如果你没有得到这块画布，那么你就无法完成任何绘图操作。
 
 
 两套支持绘图的API族：
 1. UIKit
 2. CoreGraphics
 
 1. 基于路径的绘图、变换、颜色管理、脱屏渲染，模板、渐变、遮蔽、图像数据管理、图像的创建、遮罩以及PDF文档的创建、显示和分析
 
 Core Graphics:
 1. 上下文：理解为画布
    两种方式获取一个图形的上下文：
        一、创建一个图片类型的上下文；
            调用UIGraphicsBeginImageContextWithOptions可以获取一个用来处理的图形上下文。利用该上下文，可以在其上进行绘图，生成图片。调用UIGraphicsGetImageFromCurrentImageContext就可以从当前上下文获取一个UIImage对象。需要在所有绘图操作结束之后调用UIGraphicsEndImageContext函数关闭图形上下文
        二、利用cocoa为你生成的图形上下文；
            当你子类化了一个UIView并实现了自己的drawRect：方法后，一旦drawRect：方法被调用，Cocoa就会为你创建一个图形上下文，此时你对图形上下文的所有绘图操作都会显示在UIView上。
            
 介绍两个绘图框架：
 1. UIKit：
    像UIImage、NSString（绘制文本）、UIBezierPath（绘制形状）、UIColor都知道如何绘制自己。这些类提供了功能有限但使用方便的方法来让我们完成绘图任务。一般情况下，UIKit就是我们所需要的。
 
    使用UiKit，【你只能在当前上下文中绘图】，所以如果你当前处于UIGraphicsBeginImageContextWithOptions函数或drawRect：方法中，你就可以直接使用UIKit提供的方法进行绘图。如果你持有一个context：参数，那么使用UIKit提供的方法之前，必须将该上下文参数转化为当前上下文。幸运的是，调用UIGraphicsPushContext 函数可以方便的将context：参数转化为当前上下文，记住最后别忘了调用UIGraphicsPopContext函数恢复上下文环境。

 2. Core Graphics
    这是一个绘图专用的API族，它经常被称为QuartZ或QuartZ 2D。Core Graphics是iOS上所有绘图功能的基石，包括UIKit。
    使用Core Graphics之前需要指定一个用于绘图的图形上下文（CGContextRef），这个图形上下文会在每个绘图函数中都会被用到。如果你持有一个图形上下文context：参数，那么你等同于有了一个图形上下文，这个上下文也许就是你需要用来绘图的那个。如果你当前处于UIGraphicsBeginImageContextWithOptions函数或drawRect：方法中，并没有引用一个上下文。为了使用Core Graphics，你可以调用UIGraphicsGetCurrentContext函数获得当前的图形上下文。
 */

class ViewController: UIViewController {
    var roundView: RoundView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        initRoundView()
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            self.roundView.frame = CGRect.init(x: 100, y: 100, width: UIScreen.main.bounds.size.width, height: 110)
//        }
//        textTime()
//        testConverToJsonString()
        
        // dogImage
//        testDoubleDogImage()
//        testPartDogImage()
        
        // dogCGImage
//        testSeprateCGImage()
//        testSeprateCGImageWithUIImage()
        
        // draw view
        showArrow()
        showRectWithCorner()
        showArrowViewWithClip()
        showArrowTransView()
        // Do any additional setup after loading the view.
    }
    
    private func initRoundView() {
        roundView = RoundView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 110))
        view.addSubview(roundView)
    }
    
    func textTime() {
        let now = Date.init()
        let currentInterval = now.timeIntervalSince1970
        let formate = DateFormatter.init()
        formate.dateFormat = "yy-MM-dd HH:mm:ss"
        let currentString = formate.string(from: now)
        formate.timeZone = TimeZone.init(identifier: "UTC")
        let utcString = formate.string(from: now)
        debugPrint("now = \(now), currentInterval = \(currentInterval), currentString = \(currentString), utcString = \(utcString)")
    }
    
    func testConverToJsonString() {
        let dic: [String: Any] = ["Limit": 1,
                                          "Filters": [["Values": ["\u{672a}\u{547d}\u{540d}"],
                                               "Name": "instance-name"
                                              ]
                                            ]
                                ]
        let jsondata = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let jsonString = String(data: jsondata!, encoding: .utf8)
        debugPrint(jsondata!)
        debugPrint(jsonString)
    }
    
    
}


/* UIImage 常用的绘图操作
 1. 如何将UIImage对象绘制在当前上下文中
 2. 使用image的draw方法，完成下列：平移，缩放，裁剪效果
 3. UIImage没有提供截取图片指定区域的功能。但通过创建一个较小的图形上下文并移动图片到一个适当的图形上下文坐标系内，指定区域内的图片就会被获取。
 */
extension ViewController {
    
    func testDoubleDogImage() {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 84, width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 84))
        guard let image = doubleDog() else { return}
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.systemPink
        self.view.addSubview(imageView)
        imageView.image = image
    }
    
    func testPartDogImage() {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 84, width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 84))
        guard let image = partDog() else { return}
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.systemPink
        self.view.addSubview(imageView)
        imageView.image = image
    }
    
    // 1. 平移
    func doubleDog() -> UIImage? {
        guard let dogImage = UIImage.init(named: "dog.png") else {return nil}
        let halfWidth = UIScreen.main.bounds.size.width / 2
        let height = dogImage.size.height * halfWidth / dogImage.size.width
        let size = CGSize(width: halfWidth, height: height)
        let ctxSize = CGSize(width: size.width * 2, height: size.height)
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        dogImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        dogImage.draw(in: CGRect(x: size.width, y: 0, width: size.width, height: size.height))
        guard let resuleImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil}
        UIGraphicsEndImageContext()
        return resuleImage
    }
    // 2. 缩放
    func largeDog() -> UIImage? {
        guard let dogImage = UIImage.init(named: "dog.png") else { return nil }
        let size = dogImage.size
        let ctxSize = CGSize(width: size.width * 2, height: size.height * 2)
        UIGraphicsBeginImageContext(ctxSize)
        dogImage.draw(in: CGRect(x: 0, y: 0, width: ctxSize.width, height: ctxSize.height)) // 即画布面积大于image实际面积，调用此方法image会填充满给定rect,也就产生了放大的效果，给定size小雨图片就是缩小效果
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return resultImage
    }
    // 3. 裁剪
    func partDog() -> UIImage? {
        guard let dogImage = UIImage(named: "dog.png") else {return nil}
        let size = dogImage.size
        let ctxSize = CGSize(width: size.width / 2, height: size.height / 2)
        UIGraphicsBeginImageContext(ctxSize)
        let point = CGPoint(x: -size.width / 2, y: 0)
        dogImage.draw(at: point)
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return resultImage
    }
}
/* CGImage 常用的绘图操作
 UIImage的Core Graphics版本是CGImage（具体类型是CGImageRef）。两者可以直接相互转化: 使用UIImage的CGImage属性可以访问Quartz图片数据；将CGImage作为UIImage方法imageWithCGImage:或initWithCGImage:的参数创建UIImage对象。
 一个CGImage对象可以让你获取原始图片中指定区域的图片（也可以获取指定区域外的图片，UIImage却办不到）。
 */
extension ViewController {
    func testSeprateCGImage() {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 84, width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 84))
        guard let image = coreGraphicsWithCGImage() else { return}
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.systemPink
        self.view.addSubview(imageView)
        imageView.image = image
    }
    
    func testSeprateCGImageWithUIImage() {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 84, width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 84))
        guard let image = UIKitWithCGImage() else { return}
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.systemPink
        self.view.addSubview(imageView)
        imageView.image = image
    }
    
    // 将图片拆分成两半，并分别绘制在上下文的左右两边：
    func coreGraphicsWithCGImage() -> UIImage? {
        guard let dogImage = UIImage(named: "dog.png") else { return nil }
        let size = dogImage.size
        let ctxWidth = UIScreen.main.bounds.size.width
        let ctxHeight = size.height * ctxWidth / size.width
        let ctxSize = CGSize(width: ctxWidth, height: ctxHeight)
        guard let dogCGImage = dogImage.cgImage else { return nil }
        let cgSize = CGSize(width: dogCGImage.width, height: dogCGImage.height)
//        let dogLeftImageRef = dogCGImage.cropping(to: CGRect(x: 0, y: 0, width: size.width/2, height: size.height)) // 当为@2x图的时候，image的size相对于CgImage size是CGImage的size的一半，所以这里获得的CGImage是一半。换成如下代码就可以了
//        let dogRightImageRef = dogCGImage.cropping(to: CGRect(x: size.width/2, y: 0, width: size.width/2, height: size.height))
        let dogLeftImageRef = dogCGImage.cropping(to: CGRect(x: 0, y: 0, width: cgSize.width/2, height: cgSize.height)) // 当为@2x图的时候，image的size相对于CgImage size是CGImage的size的一半，所以这里获得的CGImage是一半
        let dogRightImageRef = dogCGImage.cropping(to: CGRect(x: cgSize.width/2, y: 0, width: cgSize.width/2, height: cgSize.height))
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.draw(flip(dogLeftImageRef!)!, in: CGRect(x: 0, y: 0, width: ctxWidth/2, height: ctxHeight))
        ctx?.draw(flip(dogRightImageRef!)!, in: CGRect(x: ctxWidth/2, y: 0, width: ctxWidth/2, height: ctxHeight))
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    /*
     你也许发现绘出的图是上下颠倒的！图片的颠倒并不是因为被旋转了。当你创建了一个CGImage并使用CGContextDrawImage方法绘图就会引起这种问题。这主要是因为原始的本地坐标系统（坐标原点在左上角）与目标上下文（坐标原点在左下角）不匹配。有很多方法可以修复这个问题，其中一种方法就是使用CGContextDrawImage方法先将CGImage绘制到UIImage上，然后获取UIImage对应的CGImage，此时就得到了一个倒转的CGImage。当再调用CGContextDrawImage方法，我们就将倒转的图片还原回来了。实现代码如下：
     */
    func flip(_ imageRef: CGImage) -> CGImage? {
        let size = CGSize(width: imageRef.width, height: imageRef.height)
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.draw(imageRef, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result.cgImage
    }
    /*
     然而，这里又出现了另外一个问题：在双分辨率的设备上，如果我们的图片文件是高分辨率（@2x）版本，上面的绘图就是错误的。原因在于对于UIImage来说，在加载原始图片时使用imageNamed:方法，它会自动根据所在设备的分辨率类型选择图片，并且UIImage通过设置用来适配的scale属性补偿图片的两倍尺寸。但是一个CGImage对象并没有scale属性，它不知道图片文件的尺寸是否为两倍！所以当调用UIImage的CGImage方法，你不能假定所获得的CGImage尺寸与原始UIImage是一样的。在单分辨率和双分辨率下，一个UIImage对象的size属性值都是一样的，但是双分辨率UIImage对应的CGImage是单分辨率UIImage对应的CGImage的两倍大。所以我们需要修改上面的代码，让其在单双分辨率下都可以工作。修改见上coreGraphicsWithCGImage中的修改
     */
    
    /*
     上面的代码初看上去很繁杂，不过不用担心，这里还有另一种修复倒置问题的方案。相对于使用flip函数，你可以在绘图之前将CGImage包装进UIImage中，这样做有两大优点：

        当UIImage绘图时它会自动修复倒置问题
        当你从CGImage转化为Uimage时，可调用imageWithCGImage:scale:orientation:方法生成CGImage作为对缩放性的补偿。
     　　所以这是一个解决倒置和缩放问题的自包含方法。
     */
    func UIKitWithCGImage() -> UIImage? {
        guard let dogImage = UIImage(named: "dog.png") else { return nil }
        let dogImageSize = dogImage.size
        guard let dogCGImage = dogImage.cgImage else { return nil }
        let dogCGSize = CGSize(width: dogCGImage.width, height: dogCGImage.height)
        let dogLeftRef = dogCGImage.cropping(to: CGRect(x: 0, y: 0, width: dogCGSize.width/2, height: dogCGSize.height))
        let dogRightRef = dogCGImage.cropping(to: CGRect(x: dogCGSize.width/2, y: 0, width: dogCGSize.width/2, height: dogCGSize.height))
        let ctxWidth = UIScreen.main.bounds.size.width
        let ctxHeight = dogImageSize.height * ctxWidth / dogImageSize.width
        let ctxSize = CGSize(width: ctxWidth, height: ctxHeight)
        
        UIGraphicsBeginImageContext(ctxSize)
        let leftImage = UIImage.init(cgImage: dogLeftRef!)
        let rightImage = UIImage.init(cgImage: dogRightRef!)
        leftImage.draw(in: CGRect(x: 0, y: 0, width: ctxSize.width/2, height: ctxSize.height))
        rightImage.draw(in: CGRect(x: ctxSize.width/2, y: 0, width: ctxSize.width/2, height: ctxSize.height))
//        leftImage.draw(at: CGPoint(x: 0, y: 0))
//        rightImage.draw(at: CGPoint(x: ctxSize.width/2, y: 0))// 这样子绘制会导致缩放不一致，拼图上下有错缝
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return resultImage
    }
}

/* 绘制一个UIView
 绘制一个UIVIew最灵活的方式就是由它自己完成绘制。实际上你不是绘制一个UIView，你只是子类化了UIView并赋予子类绘制自己的能力。当一个UIVIew需要执行绘图操作的时， drawRect:方法就会被调用。覆盖此方法让你获得绘图操作的机会。当drawRect：方法被调用，当前图形上下文也被设置为属于视图的图形上下文。你可以使用Core Graphics或UIKit提供的方法将图形画到该上下文中。
 你不应该手动调用drawRect：方法！如果你想调用drawRect：方法更新视图，只需发送setNeedsDisplay方法。这将使得drawRect：方法会在下一个适当的时间调用。当然，不要覆盖drawRect：方法除非你知道这样做绝对合法。比方说，在UIImageView子类中覆盖drawRect：方法是不合法的，你将得不到你绘制的图形。
 在UIView子类的drawRect：方法中无需调用super，因为本身UIView的drawRect：方法是空的。为了提高一些绘图性能，你可以调用setNeedsDisplayInRect方法重新绘制视图的子区域，而视图的其他部分依然保持不变。
 一般情况下，你不应该过早的进行优化。绘图代码可能看上去非常的繁琐，但它们是非常快的。并且iOS绘图系统自身也是非常高效，它不会频繁调用drawRect：方法，除非迫不得已（或调用了setNeedsDisplay方法）。一旦一个视图已由自己绘制完成，那么绘制的结果会被缓存下来留待重用，而不是每次重头再来。(苹果公司将缓存绘图称为视图的位图存储回填（bitmap backing store）)。你可能会发现drawRect：方法中的代码在整个应用程序生命周期内只被调用了一次！事实上，将代码移到drawRect：方法中是提高性能的普遍做法。这是因为绘图引擎直接对屏幕进行渲染相对于先是脱屏渲染然后再将像素拷贝到屏幕要来的高效。
 当视图的backgroundColor为nil并且opaque属性为YES，视图的背景颜色就会变成黑色。
 */
extension ViewController {
    
}

/* 路径与绘图
 通过编写移动虚拟画笔的代码描画一段路径，这样的路径并不构成一个图形。绘制路径意味着对路径描边或填充该路径，也或者两者都做。同样，你应该从某些绘图程序中得到过相似的体会。
 一段路径是由点到点的描画构成。想象一下绘图系统是你手里的一只画笔，你首先必须要设置画笔当前所处的位置，然后给出一系列命令告诉画笔如何描画随后的每段路径。每一段新增的路径开始于当前点，当完成一条路径的描画，路径的终点就变成了当前点。
 下面列出了一些路径描画的命令：
 CGContextMoveToPoint 定位当前点
 CGContextAddLineToPoint、CGContextAddLines 描画一条线
 CGContextAddRect、CGContextAddRects 描画一个矩形
 CGContextAddEllipseInRect 描画一个椭圆或圆形
 CGContextAddArcToPoint、CGContextAddArc 描画一段圆弧
 CGContextAddQuadCurveToPoint、CGContextAddCurveToPoint  通过一到两个控制点描画一段贝赛尔曲线
 CGContextClosePath 关闭当前路径。这将从路径的终点到起点追加一条线。如果你打算填充一段路径，那么就不需要使用该命令，因为该命令会被自动调用。
 CGContextStrokePath、CGContextFillPath、CGContextEOFillPath、CGContextDrawPath。 描边或填充当前路径。如果你只想使用一条命令完成描边和填充任务，可以使用CGContextDrawPath命令，因为如果你只是使用CGContextStrokePath对路径描边，路径就会被清除掉，你就不能再对它进行填充了。
 创建路径并描边路径或填充路径只需一条命令就可完成的函数：CGContextStrokeLineSegments、CGContextStrokeRect、CGContextStrokeRectWithWidth、CGContextFillRect、CGContextFillRects、CGContextStrokeEllipseInRect、CGContextFillEllipseInRect。
 
 */

extension ViewController {
    func showArrow() {
        let imageView = UIImageView.init(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
//        imageView.image = drawArrow()
        imageView.image = drawArrowWithUIKit()
        imageView.backgroundColor = UIColor.green
        self.view.addSubview(imageView)
    }
    
    // 为了说明典型路径的描画命令，我将生成一个向上的箭头图案
    func drawArrow()-> UIImage? {
        let ctxSize = CGSize(width: 200, height: 100)
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        // 绘制一个黑色的垂直黑色线，作为箭头的杆子
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.move(to: CGPoint(x: 100, y: 100))
        ctx?.addLine(to: CGPoint(x: 100, y: 19))
        ctx?.setLineWidth(20)
        ctx?.strokePath()
        // 绘制一个红色三角形箭头
        ctx?.setFillColor(UIColor.red.cgColor)
        ctx?.move(to: CGPoint(x: 80, y: 25))
        ctx?.addLine(to: CGPoint(x: 100, y: 0))
        ctx?.addLine(to: CGPoint(x: 120, y: 25))
        ctx?.fillPath()
        // 从箭头杆子上裁掉一个三角形，使用清除混合模式
        ctx?.move(to: CGPoint(x: 90, y: 101))
        ctx?.addLine(to: CGPoint(x: 100, y: 91))
        ctx?.addLine(to: CGPoint(x: 110, y: 101))
        ctx?.setBlendMode(CGBlendMode.clear)
        ctx?.fillPath()
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return resultImage
    }
    /*
     如果一段路径需要重用或共享，你可以将路径封装为CGPath（具体类型是CGPathRef）。你可以创建一个新的CGMutablePathRef对象并使用多个类似于图形的路径函数的CGPath函数构造路径，或者使用CGContextCopyPath函数复制图形上下文的当前路径。有许多CGPath函数可用于创建基于简单几何形状的路径（CGPathCreateWithRect、CGPathCreateWithEllipseInRect）或基于已存在路径（CGPathCreateCopyByStrokingPath、CGPathCreateCopyDashingPath、CGPathCreateCopyByTransformingPath）。
     UIKit的UIBezierPath类包装了CGPath。它提供了用于绘制某种形状路径的方法，以及用于描边、填充、存取某些当前上下文状态的设置方法。类似地，UIColor提供了用于设置当前上下文描边与填充的颜色。因此我们可以重写我们之前绘制箭头的代码：
     */
    
    func drawArrowWithUIKit() -> UIImage? {
        let ctxSize = CGSize(width: 200, height: 100)
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        let p = UIBezierPath.init()
        p.move(to: CGPoint(x: 100, y: 100))
        p.addLine(to: CGPoint(x: 100, y: 19))
        p.lineWidth = 20
        p.stroke()
        
        UIColor.red.set()
        p.removeAllPoints()
        p.move(to: CGPoint(x: 80, y: 25))
        p.addLine(to: CGPoint(x: 120, y: 25))
        p.addLine(to: CGPoint(x: 100, y: 0))
        p.fill()
        
        p.removeAllPoints()
        p.move(to: CGPoint(x: 90, y: 101))
        p.addLine(to: CGPoint(x: 100, y: 90))
        p.addLine(to: CGPoint(x: 110, y: 101))
        p.fill(with: CGBlendMode.clear, alpha: 1.0)
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func showRectWithCorner() {
        let imageView = UIImageView.init(frame: CGRect(x: 100, y: 210, width: 200, height: 200))
        imageView.image = drawRectWithCorner()
        imageView.backgroundColor = UIColor.white
        self.view.addSubview(imageView)
    }
    
    /*
     在这种特殊情况下，完成同样的工作并没有节省多少代码，但是UIBezierPath仍然还是有用的。如果你需要对象特性，UIBezierPath提供了一个便利方法：bezierPathWithRoundedRect：cornerRadius：，它可用于绘制带有圆角的矩形，如果是使用Core Graphics就相当冗长乏味了。还可以只让圆角出现在左上角和右上角。
     */
    func drawRectWithCorner() -> UIImage? {
        let ctxSize = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        UIColor.black.set()
        let rect = CGRect(x: 50, y: 50, width: 100, height: 100)
        let p = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 10, height: 10))
        p.stroke()
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return resultImage
    }
}
/* 裁剪UI
 */
extension ViewController {
    func showArrowViewWithClip() {
        let view = ArrowView.init(frame: CGRect(x: 0, y: 420, width: 200, height: 200))
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
    }
}
/* 图形上下文变换
 */
extension ViewController {
    func showArrowTransView() {
        let view = ArrowView.init(frame: CGRect(x: 200, y: 420, width: 200, height: 200))
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
    }
}

