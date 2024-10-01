//
//  UILabel.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/04.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
//import Sybrin_iOS_Identity

// UILable Extension to allow us to add letter spacing
@IBDesignable
extension UILabel {
    
    /// Allows users to specify distance between characters on a UILabel
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            } else {
                return 0
            }
        }
    }
}
