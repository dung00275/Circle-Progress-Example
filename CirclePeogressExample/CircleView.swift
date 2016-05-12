//
//  CircleView.swift
//  CirclePeogressExample
//
//  Created by Hoang Phuong on 5/10/16.
//  Copyright © 2016 Hoang Dung. All rights reserved.
//

import Foundation
import UIKit
import CoreText

@IBDesignable
public class CircleView: UIView {
    // MARK: Class's properties
    @IBInspectable public var colorDefault: UIColor = UIColor.redColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var colorProgress1: UIColor = UIColor.grayColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var colorProgress2: UIColor = UIColor.greenColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var colorProgress3: UIColor = UIColor.yellowColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable public var lineWidthDefault: CGFloat = 15 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var progressLine1: CGFloat = 0.2 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var progressLine2: CGFloat = 0.5 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var progressLine3: CGFloat = 0.7 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var text: String? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.redColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var textFontDefault: UIFont = UIFont.systemFontOfSize(36) {
        didSet{
            setNeedsDisplay()
        }
    }

    private var progress: CGFloat = 0 {
        didSet{
            
        }
    }
    private var lineWidthProgress: CGFloat {
        return self.lineWidthDefault * 2
    }
    
    private var circleShape1: CAShapeLayer!
    private var circleShape2: CAShapeLayer!
    private var circleShape3: CAShapeLayer!
    
    private let startAngle = degreesToRadians(-110).toCGFLoat()
    private let endAngle = degreesToRadians(-70).toCGFLoat()
    
    
    // MARK: Class's constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
   
    public override func prepareForInterfaceBuilder() {
        
    }
    
    // MARK: --- Draw
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.layer.sublayers?.removeAll()
        setupView()
    
    }
    
    private func setupView() {
        createShapeOnView(lineWidth: lineWidthDefault,
                          color: colorDefault)
        circleShape3 = createShapeOnView(lineWidth: lineWidthProgress,
                                         color: colorProgress3,
                                         roundShape: true,
                                         progressDefault: progressLine3)
        
        circleShape2 = createShapeOnView(lineWidth: lineWidthProgress,
                                         color: colorProgress2,
                                         roundShape: true,
                                         isNeedTail: false,
                                         progressDefault: progressLine2)
        
        circleShape1 = createShapeOnView(lineWidth: lineWidthProgress,
                                         color: colorProgress1,
                                         roundShape: true,
                                         isNeedTail: false,
                                         progressDefault: progressLine1)
        
        
        // Create Corner
        let shapeCorner = createCircleCornerShape(lineWidth: lineWidthProgress,
                                                  color: colorProgress1)
        
        layer.addSublayer(shapeCorner)
        
        if let text = text {
            let textLayer = CATextLayer()
            textLayer.string = text
            textLayer.font = textFontDefault
            textLayer.foregroundColor = UIColor.redColor().CGColor
            textLayer.wrapped = true
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.truncationMode = kCATruncationEnd
            textLayer.contentsScale = UIScreen.mainScreen().scale
            textLayer.frame = CGRect(origin: shapeCorner.position, size: CGSizeMake(50, 50))
            layer.addSublayer(textLayer)
        }
    }
    
    // MARK: --- Default
    func createShapeOnView(lineWidth width: CGFloat,
                                     color: UIColor,
                                     roundShape : Bool = false,
                                     isNeedTail : Bool = true,
                                     progressDefault: CGFloat = 1) -> CAShapeLayer
    {
        
        // Create Circle Center
        let shapeCenter = createShapeCircle(lineWidth: width,
                                            progressDefault: progressDefault,
                                            strokeColor: color,
                                            roundShape: roundShape)
        layer.addSublayer(shapeCenter)
        
        // Create Tail
        if isNeedTail {
            let shapeTail = createTailShape(lineWidth: width,
                                            fillColor: progressDefault == 1 ? color : UIColor.clearColor())
            
            layer.addSublayer(shapeTail)
        }
        
        return shapeCenter
    }
    
    // MARK: --- Tail
    private func createTailShape(lineWidth width: CGFloat,
                                 fillColor: UIColor) -> CAShapeLayer
    {
        let layer = CAShapeLayer()
        let radius = width * 0.5
        let bezier = UIBezierPath()
        bezier.moveToPoint(CGPoint(x: -radius, y: radius))
        bezier.addLineToPoint(CGPoint(x: radius, y: radius))
        bezier.addLineToPoint(CGPoint(x: radius, y: -radius))
        bezier.addLineToPoint(CGPoint(x: -radius , y: -radius * 0.4))
        bezier.closePath()
        bezier.lineWidth = 0.5
        layer.path = bezier.CGPath
        
        
        layer.fillColor = fillColor.CGColor
        layer.strokeColor = UIColor.clearColor().CGColor
        
        let radiusView = self.bounds.size.width / 2 - 25
        
        let rotate = endAngle - width * 0.5 / radiusView + 0.01
        let x = radiusView * cos(rotate) + CGRectGetMidX(bounds)
        let y = radiusView * sin(rotate) + CGRectGetMidY(bounds) + 0.2
        layer.position = CGPointMake(x, y)
        layer.setAffineTransform(CGAffineTransformMakeRotation(rotate))
        
        return layer
    }
    
    // MARK: --- Corner
    private func createCircleCornerShape (lineWidth width: CGFloat,
                                          color: UIColor,
                                          size: CGSize = CGSizeMake(50, 50)) -> CAShapeLayer
    {
        let radius = self.bounds.size.width / 2 - 25
        let benzierPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: size))
        
        let circleCorner = CAShapeLayer()
        circleCorner.path = benzierPath.CGPath
        circleCorner.fillColor = color.CGColor
        
        let degree = startAngle - width * 0.5 / radius
        let xCircleCorner = radius * cos(degree) + CGRectGetMidX(bounds)
        let yCircleCorner = radius * sin(degree) + CGRectGetMidX(bounds) - 2 * 15
        
        circleCorner.position = CGPointMake(xCircleCorner, yCircleCorner)
        
        return circleCorner
    }
    
    // MARK: ---- Center
    private func createShapeCircle(lineWidth width: CGFloat,
                                   progressDefault: CGFloat,
                                   strokeColor: UIColor,
                                   roundShape: Bool) -> CAShapeLayer
    {
        let circle = CAShapeLayer()
        let radius = self.bounds.size.width / 2 - 25
        let benzierPath = UIBezierPath(arcCenter: CGPointZero,
                                       radius: radius,
                                       startAngle: startAngle,
                                       endAngle: endAngle,
                                       clockwise: false)
        
        circle.path = benzierPath.CGPath
        circle.position = CGPointMake(CGRectGetMidX(self.bounds),
                                      CGRectGetMidY(self.bounds))
        
        let fillColor = UIColor.clearColor()
        circle.fillColor = fillColor.CGColor
        circle.strokeColor = strokeColor.CGColor
        circle.lineDashPhase = 0
        circle.lineWidth = width
        circle.strokeEnd = progressDefault
        if roundShape {circle.lineCap = kCALineCapRound}
        
        return circle
    }
    
    
}

extension Double {
    func toCGFLoat() -> CGFloat{
        return CGFloat(self)
    }
}

func degreesToRadians(angle: Double) -> Double {
    return angle / 180 * M_PI
}