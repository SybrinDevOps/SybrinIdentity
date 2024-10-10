//
//  CGRect.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/21.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import AVFoundation

extension CGRect {
    
    func RotateLeft(containerHeight: CGFloat) -> CGRect {
        let newRectWidth = self.height
        let newRectHeight = self.width
        let newRectX = self.minY
        let newRectY = containerHeight - self.minX - newRectHeight
        
        return CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
    }
    
    func RotateRight(containerWidth: CGFloat) -> CGRect {
        let newRectWidth = self.height
        let newRectHeight = self.width
        let newRectX = containerWidth - self.minY - newRectWidth
        let newRectY = self.minX
        
        return CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
    }
    
    func FlipHorizontally(containerWidth: CGFloat) -> CGRect {
        let newRectWidth = self.width
        let newRectHeight = self.height
        let newRectX = containerWidth - self.minX - newRectWidth
        let newRectY = self.minY
        
        return CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
    }
    
    func FlipVertically(containerHeight: CGFloat) -> CGRect {
        let newRectWidth = self.width
        let newRectHeight = self.height
        let newRectX = self.minX
        let newRectY = containerHeight - self.minY - newRectHeight
        
        return CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
    }
    
    var TopLeft: CGPoint {
        return CGPoint(x: self.minX, y: self.minY)
    }
    
    var TopRight: CGPoint {
        return CGPoint(x: self.maxX, y: self.minY)
    }
    
    var BottomLeft: CGPoint {
        return CGPoint(x: self.minX, y: self.maxY)
    }
    
    var BottomRight: CGPoint {
        return CGPoint(x: self.maxX, y: self.maxY)
    }
    
}
