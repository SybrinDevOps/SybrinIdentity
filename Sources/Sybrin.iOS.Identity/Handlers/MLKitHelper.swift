//
//  MLKitHelper.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/25.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import MLKitFaceDetection  ////import MLKit

//struct MLKitHelper {
//    
//    // MARK: Internal Methods
//    static func BlocksToSybrinItemGroup(_ blocks: [TextBlock]) -> SybrinItemGroup {
//        var returnGroup = SybrinItemGroup()
//        
//        blocks: for block in blocks {
//            lines: for line in block.lines {
//                var sybrinLine = SybrinLine(text: line.text, frame: line.frame)
//                
//                elements: for element in line.elements {
//                    let sybrinElement = SybrinElement(text: element.text, frame: element.frame)
//                    
//                    returnGroup.Elements.append(sybrinElement)
//                    sybrinLine.Elements.append(sybrinElement)
//                }
//                
//                returnGroup.Lines.append(sybrinLine)
//            }
//        }
//        
//        return returnGroup
//    }
//    
//    static func GetCenterPoint(item: ProtocolSybrinItem) -> CGPoint {
//        return CGPoint(
//            x: item.Frame.midX,
//            y: item.Frame.midY
//        )
//    }
//    
//    static func DistanceBetweenPoints(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
//        return sqrt(abs(pointA.x - pointB.x) * abs(pointA.x - pointB.x) + abs(pointA.y - pointB.y) * abs(pointA.y - pointB.y))
//    }
//    
//    static func Is(item itemA: ProtocolSybrinItem, relative: RelativePosition, to itemB: ProtocolSybrinItem) -> Bool {
//        // IMPORTANT: Image orientation is landscape left, so coordinates are rotated (the top of the image is to the right of the screen)
//        
//        guard itemA.Frame != itemB.Frame else { return false }
//        
//        switch relative {
//            case .Above: guard itemA.Frame.minX >= itemB.Frame.midX else { return false }
//            case .Below: guard itemA.Frame.maxX <= itemB.Frame.midX else { return false }
//            case .Left: guard itemA.Frame.maxY <= itemB.Frame.midY else { return false }
//            case .Right: guard itemA.Frame.minY >= itemB.Frame.midY else { return false }
//        }
//        
//        return true
//    }
//    
//    static func GetItemsThatMatchConstraints(items: [ProtocolSybrinItem], constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)]) -> [ProtocolSybrinItem] {
//        var result: [ProtocolSybrinItem] = []
//        
//        for item in items {
//            for constraint in constraints {
//                if Is(item: item, relative: constraint.relative, to: constraint.item) {
//                    result.append(item)
//                }
//            }
//        }
//        
//        return result
//    }
//    
//    static func GetClosestItem(from currentItem: ProtocolSybrinItem, items: [ProtocolSybrinItem], constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)]) -> ProtocolSybrinItem? {
//        // IMPORTANT: Image orientation is landscape left, so coordinates are rotated (the top of the image is to the right of the screen)
//        
//        var closestItem: ProtocolSybrinItem?
//        let currentItemCenterPoint = GetCenterPoint(item: currentItem)
//        
//        let possibleResults = GetItemsThatMatchConstraints(items: items, constraints: constraints)
//        
//        for possibleResult in possibleResults {
//            if closestItem == nil || DistanceBetweenPoints(pointA: GetCenterPoint(item: possibleResult), pointB: currentItemCenterPoint) <= DistanceBetweenPoints(pointA: GetCenterPoint(item: closestItem!), pointB: currentItemCenterPoint) {
//                closestItem = possibleResult
//            }
//        }
//        
//        return closestItem
//    }
//    
//    static func GetClosestItemAbove(from currentItem: ProtocolSybrinItem, items: [ProtocolSybrinItem], aligned: HorizontalAlignment = .Inline, threshold: CGFloat? = nil, constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []) -> ProtocolSybrinItem? {
//        // IMPORTANT: Image orientation is landscape left, so coordinates are rotated (the top of the image is to the right of the screen)
//        
//        let currentItemCenterPoint = GetCenterPoint(item: currentItem)
//        var closestItem: ProtocolSybrinItem?
//        let threshold = (threshold == nil) ? currentItem.Frame.width : threshold!
//            
//        search: for offsetItem in items {
//            guard currentItem.Frame != offsetItem.Frame else { continue search }
//            
//            // Position check / Check if the item is really above
//            guard offsetItem.Frame.minX - currentItem.Frame.maxX <= threshold && Is(item: offsetItem, relative: .Above, to: currentItem) else { continue search }
//            
//            // Alignment check / Check if the item matches the desired alignment
//            switch aligned {
//                case .Inline: guard offsetItem.Frame.maxY >= currentItem.Frame.minY && offsetItem.Frame.minY <= currentItem.Frame.maxY else { continue search }
//                case .InlineThreshold: guard offsetItem.Frame.maxY + threshold >= currentItem.Frame.minY && offsetItem.Frame.minY <= currentItem.Frame.maxY + threshold else { continue search }
//                case .Left: guard abs(currentItem.Frame.minY - offsetItem.Frame.minY) <= threshold else { continue search }
//                case .Center: guard abs(currentItem.Frame.midY - offsetItem.Frame.midY) <= threshold else { continue search }
//                case .Right: guard abs(currentItem.Frame.maxY - offsetItem.Frame.maxY) <= threshold else { continue search }
//                case .Ignore: break
//            }
//            
//            // Constraints check / Check if the item is within all custom defined constraints
//            for constraint in constraints {
//                guard Is(item: offsetItem, relative: constraint.relative, to: constraint.item) else { continue search }
//            }
//            
//            // Check if the item is closer than any item already found before
//            guard let closestItemLocal = closestItem else {
//                closestItem = offsetItem
//                continue search
//            }
//            switch aligned {
//                case .Ignore, .Inline, .InlineThreshold, .Center:
//                    if DistanceBetweenPoints(pointA: GetCenterPoint(item: offsetItem), pointB: currentItemCenterPoint) <= DistanceBetweenPoints(pointA: GetCenterPoint(item: closestItemLocal), pointB: currentItemCenterPoint) {
//                        closestItem = offsetItem
//                    }
//                case .Left:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.TopRight, pointB: currentItem.Frame.TopRight) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.TopRight, pointB: currentItem.Frame.TopRight) {
//                        closestItem = offsetItem
//                    }
//                case .Right:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.BottomRight, pointB: currentItem.Frame.BottomRight) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.BottomRight, pointB: currentItem.Frame.BottomRight) {
//                        closestItem = offsetItem
//                    }
//            }
//            
//        }
//        
//        return closestItem
//    }
//    
//    static func GetClosestItemBelow(from currentItem: ProtocolSybrinItem, items: [ProtocolSybrinItem], aligned: HorizontalAlignment = .Inline, threshold: CGFloat? = nil, constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []) -> ProtocolSybrinItem? {
//        // IMPORTANT: Image orientation is landscape left, so coordinates are rotated (the top of the image is to the right of the screen)
//        
//        let currentItemCenterPoint = GetCenterPoint(item: currentItem)
//        var closestItem: ProtocolSybrinItem?
//        let threshold = (threshold == nil) ? currentItem.Frame.width : threshold!
//            
//        search: for offsetItem in items {
//            guard currentItem.Frame != offsetItem.Frame else { continue search }
//            
//            // Position check / Check if the item is really below
//            guard currentItem.Frame.minX - offsetItem.Frame.maxX <= threshold && Is(item: offsetItem, relative: .Below, to: currentItem) else { continue search }
//            
//            // Alignment check / Check if the item matches the desired alignment
//            switch aligned {
//                case .Inline: guard offsetItem.Frame.maxY >= currentItem.Frame.minY && offsetItem.Frame.minY <= currentItem.Frame.maxY else { continue search }
//                case .InlineThreshold: guard offsetItem.Frame.maxY + threshold >= currentItem.Frame.minY && offsetItem.Frame.minY <= currentItem.Frame.maxY + threshold else { continue search }
//                case .Left: guard abs(currentItem.Frame.minY - offsetItem.Frame.minY) <= threshold else { continue search }
//                case .Center: guard abs(currentItem.Frame.midY - offsetItem.Frame.midY) <= threshold else { continue search }
//                case .Right: guard abs(currentItem.Frame.maxY - offsetItem.Frame.maxY) <= threshold else { continue search }
//                case .Ignore: break
//            }
//            
//            // Constraints check / Check if the item is within all custom defined constraints
//            for constraint in constraints {
//                guard Is(item: offsetItem, relative: constraint.relative, to: constraint.item) else { continue search }
//            }
//            
//            // Check if the item is closer than any item already found before
//            guard let closestItemLocal = closestItem else {
//                closestItem = offsetItem
//                continue search
//            }
//            switch aligned {
//                case .Ignore, .Inline, .InlineThreshold, .Center:
//                    if DistanceBetweenPoints(pointA: GetCenterPoint(item: offsetItem), pointB: currentItemCenterPoint) <= DistanceBetweenPoints(pointA: GetCenterPoint(item: closestItemLocal), pointB: currentItemCenterPoint) {
//                        closestItem = offsetItem
//                    }
//                case .Left:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.TopRight, pointB: currentItem.Frame.TopRight) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.TopRight, pointB: currentItem.Frame.TopRight) {
//                        closestItem = offsetItem
//                    }
//                case .Right:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.BottomRight, pointB: currentItem.Frame.BottomRight) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.BottomRight, pointB: currentItem.Frame.BottomRight) {
//                        closestItem = offsetItem
//                    }
//            }
//            
//        }
//        
//        return closestItem
//    }
//    
//    static func GetClosestItemToTheLeft(from currentItem: ProtocolSybrinItem, items: [ProtocolSybrinItem], aligned: VerticalAlignment = .Inline, threshold: CGFloat? = nil, constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []) -> ProtocolSybrinItem? {
//        // IMPORTANT: Image orientation is landscape left, so coordinates are rotated (the top of the image is to the right of the screen)
//        
//        let currentItemCenterPoint = GetCenterPoint(item: currentItem)
//        var closestItem: ProtocolSybrinItem?
//        let threshold = (threshold == nil) ? currentItem.Frame.height : threshold!
//            
//        search: for offsetItem in items {
//            guard currentItem.Frame != offsetItem.Frame else { continue search }
//            
//            // Position check / Check if the item is really to the left
//            guard currentItem.Frame.minY - offsetItem.Frame.maxY <= threshold && Is(item: offsetItem, relative: .Left, to: currentItem) else { continue search }
//            
//            // Alignment check / Check if the item matches the desired alignment
//            switch aligned {
//                case .Inline: guard offsetItem.Frame.maxX >= currentItem.Frame.minX && offsetItem.Frame.minX <= currentItem.Frame.maxX else { continue search }
//                case .InlineThreshold: guard offsetItem.Frame.maxX + threshold >= currentItem.Frame.minX && offsetItem.Frame.minX <= currentItem.Frame.maxX + threshold else { continue search }
//                case .Top: guard abs(currentItem.Frame.maxX - offsetItem.Frame.maxX) <= threshold else { continue search }
//                case .Center: guard abs(currentItem.Frame.midX - offsetItem.Frame.midX) <= threshold else { continue search }
//                case .Bottom: guard abs(currentItem.Frame.minX - offsetItem.Frame.minX) <= threshold else { continue search }
//                case .Ignore: break
//            }
//            
//            // Constraints check / Check if the item is within all custom defined constraints
//            for constraint in constraints {
//                guard Is(item: offsetItem, relative: constraint.relative, to: constraint.item) else { continue search }
//            }
//            
//            // Check if the item is closer than any item already found before
//            guard let closestItemLocal = closestItem else {
//                closestItem = offsetItem
//                continue search
//            }
//            switch aligned {
//                case .Ignore, .Inline, .InlineThreshold, .Center:
//                    if DistanceBetweenPoints(pointA: GetCenterPoint(item: offsetItem), pointB: currentItemCenterPoint) <= DistanceBetweenPoints(pointA: GetCenterPoint(item: closestItemLocal), pointB: currentItemCenterPoint) {
//                        closestItem = offsetItem
//                    }
//                case .Top:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.TopRight, pointB: currentItem.Frame.TopRight) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.TopRight, pointB: currentItem.Frame.TopRight) {
//                        closestItem = offsetItem
//                    }
//                case .Bottom:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.TopLeft, pointB: currentItem.Frame.TopLeft) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.TopLeft, pointB: currentItem.Frame.TopLeft) {
//                        closestItem = offsetItem
//                    }
//            }
//            
//        }
//        
//        return closestItem
//    }
//    
//    static func GetClosestItemToTheRight(from currentItem: ProtocolSybrinItem, items: [ProtocolSybrinItem], aligned: VerticalAlignment = .Inline, threshold: CGFloat? = nil, constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []) -> ProtocolSybrinItem? {
//        // IMPORTANT: Image orientation is landscape left, so coordinates are rotated (the top of the image is to the right of the screen)
//        
//        let currentItemCenterPoint = GetCenterPoint(item: currentItem)
//        var closestItem: ProtocolSybrinItem?
//        let threshold = (threshold == nil) ? currentItem.Frame.height : threshold!
//            
//        search: for offsetItem in items {
//            guard currentItem.Frame != offsetItem.Frame else { continue search }
//            
//            // Position check / Check if the item is really to the right
//            guard offsetItem.Frame.minY - currentItem.Frame.maxY <= threshold && Is(item: offsetItem, relative: .Right, to: currentItem) else { continue search }
//            
//            // Alignment check / Check if the item matches the desired alignment
//            switch aligned {
//                case .Inline: guard offsetItem.Frame.maxX >= currentItem.Frame.minX && offsetItem.Frame.minX <= currentItem.Frame.maxX else { continue search }
//                case .InlineThreshold: guard offsetItem.Frame.maxX + threshold >= currentItem.Frame.minX && offsetItem.Frame.minX <= currentItem.Frame.maxX + threshold else { continue search }
//                case .Top: guard abs(currentItem.Frame.maxX - offsetItem.Frame.maxX) <= threshold else { continue search }
//                case .Center: guard abs(currentItem.Frame.midX - offsetItem.Frame.midX) <= threshold else { continue search }
//                case .Bottom: guard abs(currentItem.Frame.minX - offsetItem.Frame.minX) <= threshold else { continue search }
//                case .Ignore: break
//            }
//            
//            // Constraints check / Check if the item is within all custom defined constraints
//            for constraint in constraints {
//                guard Is(item: offsetItem, relative: constraint.relative, to: constraint.item) else { continue search }
//            }
//            
//            // Check if the item is closer than any item already found before
//            guard let closestItemLocal = closestItem else {
//                closestItem = offsetItem
//                continue search
//            }
//            switch aligned {
//                case .Ignore, .Inline, .InlineThreshold, .Center:
//                    if DistanceBetweenPoints(pointA: GetCenterPoint(item: offsetItem), pointB: currentItemCenterPoint) <= DistanceBetweenPoints(pointA: GetCenterPoint(item: closestItemLocal), pointB: currentItemCenterPoint) {
//                        closestItem = offsetItem
//                    }
//                case .Top:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.TopRight, pointB: currentItem.Frame.TopRight) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.TopRight, pointB: currentItem.Frame.TopRight) {
//                        closestItem = offsetItem
//                    }
//                case .Bottom:
//                    if DistanceBetweenPoints(pointA: offsetItem.Frame.TopLeft, pointB: currentItem.Frame.TopLeft) <= DistanceBetweenPoints(pointA: closestItemLocal.Frame.TopLeft, pointB: currentItem.Frame.TopLeft) {
//                        closestItem = offsetItem
//                    }
//            }
//            
//        }
//        
//        return closestItem
//    }
//    
//}
