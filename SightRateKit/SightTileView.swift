//
//  SightTileView.swift
//  AutolayoutTest
//
//  Created by Arash Kashi on 30/09/14.
//  Copyright (c) 2014 Wooga. All rights reserved.
//

import UIKit

@IBDesignable

class SightTileView: UIView {
    
    var backgroundRingLayer: CAShapeLayer!
    var ringLayer: CAShapeLayer!
    var imageLayer: CALayer!
    var image: UIImage? {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable var rating: CGFloat = 0.6 {
        didSet { updateLayerProperties() }
    }
    @IBInspectable var lineWidth: CGFloat = 10.0 {
        didSet { updateLayerProperties() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if ( backgroundRingLayer == nil) {
            backgroundRingLayer = CAShapeLayer()
            layer.addSublayer(self.backgroundRingLayer)
            
            let rect = CGRectInset(bounds, lineWidth/2.0, lineWidth/2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundRingLayer.path = path.CGPath
            backgroundRingLayer.fillColor = nil
            backgroundRingLayer.lineWidth = lineWidth
            backgroundRingLayer.strokeColor = UIColor(white: 0.5, alpha: 0.3).CGColor
        }
        
        self.backgroundRingLayer.frame = self.layer.bounds
        
        if ringLayer == nil {
            ringLayer = CAShapeLayer()
            
            let innerRect = CGRectInset(bounds, lineWidth/2.0, lineWidth/2.0)
            let innerPath = UIBezierPath(ovalInRect: innerRect)
            
            ringLayer.path = innerPath.CGPath
            ringLayer.fillColor = nil
            ringLayer.lineWidth = lineWidth
            ringLayer.strokeColor = UIColor.blueColor().CGColor
            ringLayer.anchorPoint = CGPointMake(0.5, 0.5)
            ringLayer.transform = CATransform3DRotate(ringLayer.transform, (CGFloat)(-M_PI/2), 0, 0, 1)
            layer.addSublayer(ringLayer)
        }
        ringLayer.frame = layer.bounds
        
        if imageLayer == nil {
            let imageMaskLayer = CAShapeLayer()
            let insetBounds = CGRectInset(bounds, lineWidth + 3.0, lineWidth + 3.0)
            let innerPath = UIBezierPath(ovalInRect: insetBounds)
            
            imageMaskLayer.path = innerPath.CGPath
            imageMaskLayer.fillColor = UIColor.blackColor().CGColor
            imageMaskLayer.frame = bounds
            //            layer.addSublayer(imageMaskLayer)
            
            imageLayer = CALayer()
            imageLayer.mask = imageMaskLayer
            imageLayer.frame = bounds
            imageLayer.backgroundColor = UIColor.lightGrayColor().CGColor
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            
            layer.addSublayer(imageLayer)
        }
        
        
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        if (ringLayer != nil) {
            ringLayer.strokeEnd = rating
            
            var strokeColor = UIColor.lightGrayColor()
            switch rating {
            case let r where r >= 0.75:
                strokeColor = UIColor(hue: 112.0/360.0, saturation: 0.39, brightness: 0.85, alpha: 1.0)
            case let r where r >= 0.5:
                strokeColor = UIColor(hue: 208.0/360, saturation: 0.51, brightness: 0.75, alpha: 1.0)
            case let r where r >= 0.25:
                strokeColor = UIColor(hue: 40.0/360.0, saturation: 0.39, brightness: 0.85, alpha: 1.0)
            default:
                strokeColor = UIColor(hue: 359.0/360.0, saturation: 0.48, brightness: 0.63, alpha: 1.0)
            }
            
            ringLayer.strokeColor = strokeColor.CGColor
            
            if (imageLayer != nil) {
                if let i = image {
                    imageLayer.contents = i.CGImage
                }
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let projectPaths = NSProcessInfo.processInfo().environment["IB_PROJECT_SOURCE_DIRECTORIES"]?.componentsSeparatedByString(",")
        
        if let counter = projectPaths?.count {
            if let projectPath = projectPaths![0] as? String {
                let imagePath = projectPath.stringByAppendingPathComponent("/SightRateKit/test.png")
                image = UIImage(contentsOfFile: imagePath)
            }
        }
        
    }
    
//    func imageLayerr() {
//        if let i = image {
//            imageLayer.contents = i.CGImage
//        }
//    }

}
