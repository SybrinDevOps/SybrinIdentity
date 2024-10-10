//
//  IdentityUI.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import Foundation
import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

struct IdentityUI {
    
    // MARK: Private Properties
    // CutOut dimensions
    private static let DriversLicenseHeightRatio: CGFloat = 0.63218390804
    private static let DriversLicenseWidthPercentage: CGFloat = 0.9
    
    private static let GreenBookHeightRatio: CGFloat = 1.41025641026
    private static let GreenBookWidthPercentage: CGFloat = 0.85
    
    private static let IDCardHeightRatio: CGFloat = 0.63218390804
    private static let IDCardWidthPercentage: CGFloat = 0.9
    
    private static let PassportHeightRatio: CGFloat = 0.696
    private static let PassportWidthPercentage: CGFloat = 0.9
    
    private static let VisaHeightRatio: CGFloat = 0.705128
    // x: 55, y:78
    private static let VisaWidthPercentage: CGFloat = 0.9
    
    private static let AccessCardHeightRatio: CGFloat = 1.49218390804
    private static let AccessCardWidthPercentage: CGFloat = 0.8
        
    private static let A4HeightRatio: CGFloat = 1.53218390804
    private static let A4WidthPercentage: CGFloat = 0.9
    
    private static let BookHeightRatio: CGFloat = 0.89218390804
    private static let BookWidthPercentage: CGFloat = 0.79
    
    private static let A4LHeightRatio: CGFloat = 0.8
    private static let A4LWidthPercentage: CGFloat = 0.99

    
    // Bundle
    private static var FrameworkBundlePath = Bundle.main.path(forResource: "Sybrin_iOS_Identity", ofType: "framework", inDirectory: "Frameworks") ?? ""
    
    // MARK: Private Methods
    private static func AddDocumentOverlay(_ view: UIView, cutoutWidthPercentage: CGFloat, cutoutHeightRatio: CGFloat, withAnimationOverlay: Bool = false, withMessage scanMessage: String) {
        let cameraPreviewWidth = view.frame.width
        let cameraPreviewHeight = view.frame.height
        
        let overlayWidth = (cameraPreviewWidth * cutoutWidthPercentage)
        let overlayHeight = overlayWidth * cutoutHeightRatio
        
        let overlayY = ((cameraPreviewHeight / 2) - (overlayHeight / 2))
        let overlayX = ((cameraPreviewWidth / 2) - (overlayWidth / 2))
        
        let overlayRect: CGRect = CGRect(x: overlayX, y: overlayY, width: overlayWidth , height: overlayHeight)
        let overlayView: UIView = UIView(frame: overlayRect)
        overlayView.tag = IdentityUITags.DOCUMENT_OVERLAY_UI_TAG.rawValue
        
        // Adding the overlay to the camera preview layer
        view.addSubview(overlayView)
        
        // Setting point values
        CommonUI.labelStartPoint = CGPoint(x: CGFloat(overlayX), y: CGFloat(overlayY))
        CommonUI.subLabelStartPoint = CGPoint(x: CGFloat(overlayX), y: CGFloat(overlayY + (overlayHeight)))
        
        // Add Overlay
        CommonUI.addOverlay(to: view)
        
        let cornerRadius: CGFloat = SybrinIdentity.shared.configuration?.cutoutCornerRadius ?? SybrinIdentityConfiguration.CutoutCornerRadius
        
        // Adding Background cut out
        CommonUI.addRectCutouts(addBorder: false, withRoundedCorners: (width: cornerRadius, height: cornerRadius), overlayView)
        
        // Adding Border
        CommonUI.addOutsideCornerBorders(to: overlayView)
        
        // Adding Labels
        CommonUI.updateLabelText(to: scanMessage, animationColor: nil)
        CommonUI.updateSubLabelText(to: "", animationColor: nil)
        
        if withAnimationOverlay {
            // Adding Animated Card Flip
            AddOverlayRotateCard(overlayView)
        }
    }
    
    private static func AddOverlayRotateCard(_ view: UIView) {
        let animatedViewX: CGFloat = 0
        let animatedViewY: CGFloat = 0
        let animatedViewWidth = view.frame.width
        let animatedViewHeight = view.frame.height
        let animatedViewFrame = CGRect(x: animatedViewX, y: animatedViewY, width: animatedViewWidth, height: animatedViewHeight)
        
        let animatedView = UIView(frame: animatedViewFrame)
        animatedView.alpha = 1
        animatedView.tag = IdentityUITags.ANIMATED_VIEW_TAG.rawValue
        animatedView.backgroundColor = UIColor.clear
        animatedView.layer.borderColor = UIColor.white.cgColor
        animatedView.layer.borderWidth = 0
        
        // Adding the subview and bringing it to the front
        view.addSubview(animatedView)
        view.bringSubviewToFront(animatedView)
    }
    
    // MARK: Internal Methods
    static func AnimateRotateCard(_ parentView: UIView, forward: Bool = true, completion: @escaping (Bool) -> ()) {
        if let animatedView = parentView.viewWithTag(IdentityUITags.ANIMATED_VIEW_TAG.rawValue) {
            
            // Rotated Transform
            var transform = CATransform3DIdentity
            transform.m34 = CGFloat(-1) / animatedView.bounds.width
            transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0)
            
            let x = animatedView.frame.maxX / 2 - (animatedView.frame.maxX / 2)
            let y = animatedView.frame.maxY / 2 - (animatedView.frame.maxY / 2)
            let rect = CGRect(x: x, y: y, width: animatedView.frame.width, height: animatedView.frame.height)
            
            // Adding Image the view (Front)
            let imageView: UIImageView = UIImageView(frame: rect)
            let backImageView: UIImageView = UIImageView(frame: rect)
            
            if forward {
                if let frontImage = UIImage(named: "animation_card_front", in: Bundle(url: NSURL(fileURLWithPath: FrameworkBundlePath) as URL), compatibleWith: nil) {
                    let cardFront: UIImage = frontImage
                    
                    imageView.image = cardFront
                    imageView.contentMode = .scaleAspectFit
                    
                    animatedView.addSubview(imageView)
                    animatedView.bringSubviewToFront(imageView)
                    animatedView.setNeedsDisplay()
                }
                
                // (Back)
                if let backImage = UIImage(named: "animation_card_back", in: Bundle(url: NSURL(fileURLWithPath: FrameworkBundlePath) as URL), compatibleWith: nil) {
                    let cardback: UIImage = backImage
                    
                    backImageView.image = cardback
                    backImageView.contentMode = .scaleAspectFit
                    backImageView.layer.transform = transform
                    
                    animatedView.addSubview(backImageView)
                    animatedView.sendSubviewToBack(backImageView)
                    animatedView.setNeedsDisplay()
                }
                
                // Animating the alpha
                UIView.animate(withDuration: TimeInterval(exactly: 0.900)!, animations: {
                    animatedView.alpha = 1
                })
                
                // Rotating the front card image
                UIView.animate(withDuration: TimeInterval(exactly: 0.600)!, delay: TimeInterval(exactly: 0)!, options: [.curveEaseInOut], animations: {
                    imageView.layer.transform = transform
                }) { (completed) in
                    UIView.animate(withDuration: TimeInterval(exactly: 0.100)!, delay: TimeInterval(exactly: 0)!, options: [.curveEaseOut], animations: {
                        imageView.alpha = 0
                    })
                }
                
                // Rotating the back card image
                UIView.animate(withDuration: TimeInterval(exactly: 0.600)!, delay: 0.550, options: [.curveEaseInOut], animations: {
                    backImageView.layer.transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0)
                }) { (completed) in
                    UIView.animate(withDuration: TimeInterval(exactly: 0.100)!, delay: TimeInterval(exactly: 0)!, options: [.curveEaseOut], animations: {
                        backImageView.alpha = 0
                    })
                    completion(true)
                }
            } else {
                if let backImage = UIImage(named: "animation_card_back", in: Bundle(url: NSURL(fileURLWithPath: FrameworkBundlePath) as URL), compatibleWith: nil) {
                    let cardBack: UIImage = backImage
                    
                    backImageView.image = cardBack
                    backImageView.contentMode = .scaleAspectFit
                    
                    animatedView.addSubview(backImageView)
                    animatedView.bringSubviewToFront(backImageView)
                    animatedView.setNeedsDisplay()
                }
                
                // (Front)
                if let frontImage = UIImage(named: "animation_card_front", in: Bundle(url: NSURL(fileURLWithPath: FrameworkBundlePath) as URL), compatibleWith: nil) {
                    let cardfront: UIImage = frontImage
                    
                    imageView.image = cardfront
                    imageView.contentMode = .scaleAspectFit
                    imageView.layer.transform = transform
                    
                    animatedView.addSubview(imageView)
                    animatedView.sendSubviewToBack(imageView)
                    animatedView.setNeedsDisplay()
                }
                
                // Animating the alpha
                UIView.animate(withDuration: TimeInterval(exactly: 0.900)!, animations: {
                    animatedView.alpha = 1
                })
                
                // Rotating the back card image
                UIView.animate(withDuration: TimeInterval(exactly: 0.600)!, delay: TimeInterval(exactly: 0)!, options: [.curveEaseInOut], animations: {
                    backImageView.layer.transform = transform
                }) { (completed) in
                    UIView.animate(withDuration: TimeInterval(exactly: 0.100)!, delay: TimeInterval(exactly: 0)!, options: [.curveEaseOut], animations: {
                        backImageView.alpha = 0
                    })
                }
                
                // Rotating the front card image
                UIView.animate(withDuration: TimeInterval(exactly: 0.600)!, delay: 0.550, options: [.curveEaseInOut], animations: {
                    imageView.layer.transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0)
                }) { (completed) in
                    UIView.animate(withDuration: TimeInterval(exactly: 0.100)!, delay: TimeInterval(exactly: 0)!, options: [.curveEaseOut], animations: {
                        imageView.alpha = 0
                    })
                    completion(true)
                }
            }
        }
    }
    
    static func AddDriversLicenseOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanFrontCard.stringValue) {
        AddDocumentOverlay(view, cutoutWidthPercentage: DriversLicenseWidthPercentage, cutoutHeightRatio: DriversLicenseHeightRatio, withAnimationOverlay: true, withMessage: scanMessage)
    }
    
    static func AddGreenBookOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
        AddDocumentOverlay(view, cutoutWidthPercentage: GreenBookWidthPercentage, cutoutHeightRatio: GreenBookHeightRatio, withMessage: scanMessage)
    }
    
    static func AddIDCardOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanFrontCard.stringValue) {
        AddDocumentOverlay(view, cutoutWidthPercentage: IDCardWidthPercentage, cutoutHeightRatio: IDCardHeightRatio, withAnimationOverlay: true, withMessage: scanMessage)
    }
    
    static func AddPassportOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
        AddDocumentOverlay(view, cutoutWidthPercentage: PassportWidthPercentage, cutoutHeightRatio: PassportHeightRatio, withMessage: scanMessage)
    }
    
    static func AddVisaOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
        AddDocumentOverlay(view, cutoutWidthPercentage: VisaWidthPercentage, cutoutHeightRatio: VisaHeightRatio, withMessage: scanMessage)
    }
    
    static func AddGenericDocumentOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
        CommonUI.addBackButton(to: view)
        CommonUI.addFlashLightButton(to: view)
        
        CommonUI.labelStartPoint = CGPoint(x: CGFloat(0), y: CGFloat(175))
        CommonUI.updateLabelText(view: view, to: scanMessage, animationColor: nil)
        
        CommonUI.subLabelStartPoint = CGPoint(x: CGFloat(0), y: CGFloat(400))
        CommonUI.updateSubLabelText(view: view, to: "", animationColor: nil)
    }
    
    static func AddAccessCardOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
            AddDocumentOverlay(view, cutoutWidthPercentage: AccessCardWidthPercentage, cutoutHeightRatio: AccessCardHeightRatio, withMessage: scanMessage)
    }
        
    static func AddBookDocumentOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
            AddDocumentOverlay(view, cutoutWidthPercentage: BookWidthPercentage, cutoutHeightRatio: BookHeightRatio, withMessage: scanMessage)
    }
    
    static func AddA4DocumentOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
            AddDocumentOverlay(view, cutoutWidthPercentage: A4WidthPercentage, cutoutHeightRatio: A4HeightRatio, withMessage: scanMessage)
    }
    
    static func AddA4LandscapeDocumentOverlay(_ view: UIView, withMessage scanMessage: String = NotifyMessage.ScanDocument.stringValue) {
            AddDocumentOverlay(view, cutoutWidthPercentage: A4LWidthPercentage, cutoutHeightRatio: A4LHeightRatio, withMessage: scanMessage)
    }

}



extension String {
    func localized(lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        guard let path = path else {
            return self
        }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle!, value: self, comment: self)
    }
}
