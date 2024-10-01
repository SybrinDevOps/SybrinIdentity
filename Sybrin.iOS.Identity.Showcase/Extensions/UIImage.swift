//
//  UIImage.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func fromGradient(colors: [UIColor], locations: [CGFloat], horizontal: Bool, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map {$0.cgColor} as CFArray
        let grad = CGGradient(colorsSpace: colorSpace, colors: cgColors , locations: locations)
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = horizontal ? CGPoint(x: size.width, y: 0) : CGPoint(x: 0, y: size.height)
        
        context?.drawLinearGradient(grad!, start: startPoint, end: endPoint, options: .drawsAfterEndLocation)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    public func blendWithGradientAndRect(blendMode: CGBlendMode, colors: [UIColor], locations: [CGFloat], horizontal: Bool = false, alpha: CGFloat = 1.0, rect: CGRect) -> UIImage {
        
        let imageColor = UIImage.fromGradient(colors: colors, locations: locations, horizontal: horizontal, size: size)
        
        let rectImage = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // fill the background with white so that translucent colors get lighter
        context!.setFillColor(UIColor.white.cgColor)
        context!.fill(rectImage)
        
        self.draw(in: rectImage, blendMode: .normal, alpha: 1)
        imageColor.draw(in: rect, blendMode: blendMode, alpha: alpha)
        
        // grab the finished image and return it
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        //self.backgroundImageView.image = result
        UIGraphicsEndImageContext()
        return result!
        
    }
    
}
