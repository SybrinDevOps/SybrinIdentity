//
//  SybrinButton.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

@IBDesignable
public class SybrinButton: UIButton {
    
    // Tag for the background button
    private let btnBackgroundTag: Int = 090
    
    // --------------------------------
    // MARK: - IBInspectable Properties
    // --------------------------------
    
    @IBInspectable
    public var backgroundColour: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    
    @IBInspectable
    var touchedBackgroundColour: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    @IBInspectable
    var cornerRadius: CGFloat =  6.5
    
    @IBInspectable
    var tocuhedTitleColor: UIColor =  UIColor(red: 0, green: 0, blue: (30 / 355), alpha: 1)
    
    // --------------------------
    // MARK: - UIButton Overrides
    // --------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedBGColor()
        super.touchesBegan(touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        initBGColor()
        super.touchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        initBGColor()
        super.touchesCancelled(touches, with: event)
    }
    
    // ----------------------------------
    // MARK: - Custom Button UI Functions
    // ----------------------------------
    
    private func setup() {
        initBackground()
    }
    
    private func initBackground() {
        if let _ = viewWithTag(btnBackgroundTag) { } else {
            let viewRect: CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
            let backgroundView: UIView =  UIView(frame: viewRect)
            backgroundView.clipsToBounds = true
            backgroundView.layer.cornerRadius = self.frame.size.height / 2
            
            backgroundView.tag = btnBackgroundTag
            
            self.addSubview(backgroundView)
            self.sendSubviewToBack(backgroundView)
            
            backgroundView.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
            
            initBGColor()
        }
    }
    
    public func initBGColor() {
        if let subView = viewWithTag(btnBackgroundTag) {
            subView.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
            self.titleLabel?.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: TimeInterval(exactly: 0.200)!, delay: 0, options: [.curveEaseIn], animations: {
                // Changing the color for the button background
                subView.backgroundColor = self.backgroundColour
                self.sendSubviewToBack(subView)
                
                // Changing the color for text
                self.setTitleColor(UIColor.white, for: .normal)
            }, completion: nil)
        }
    }
    
    public func animateTouchedBGColor(_ delay: Double = 0, done: @escaping (Bool) -> ()?) {
        if let subView = viewWithTag(btnBackgroundTag) {
            UIView.animate(withDuration: TimeInterval(exactly: 1)!, delay: TimeInterval(exactly: delay)!, options: [.curveEaseIn, .autoreverse], animations: {
                
                subView.backgroundColor = self.touchedBackgroundColour
                self.sendSubviewToBack(subView)
                
                // Changing the color for text
                self.setTitleColor(self.tocuhedTitleColor, for: .normal)
            }) { (completed) in
                done(completed)
            }
        }
    }
    
    private func touchedBGColor() {
        if let subView = viewWithTag(btnBackgroundTag) {
            subView.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
            self.titleLabel?.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: TimeInterval(exactly: 0.200)!, delay: 0, options: [.curveEaseIn], animations: {
                // Changing the color for the button background
                subView.backgroundColor = self.touchedBackgroundColour
                self.sendSubviewToBack(subView)
                
                // Changing the color for text
                self.setTitleColor(self.tocuhedTitleColor, for: .normal)
            }, completion: nil)
        }
    }
    
    public func updateButtonColours(_ textColour: UIColor, backgroundColour: UIColor) {
        if let subView = viewWithTag(btnBackgroundTag) {
            subView.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
            self.titleLabel?.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: TimeInterval(exactly: 0.200)!, delay: 0, options: [.curveEaseIn], animations: {
                subView.backgroundColor = backgroundColour
                self.sendSubviewToBack(subView)
                
                // Changing the color for text
                self.setTitleColor(textColour, for: .normal)
            }, completion: nil)
        }
    }
    
    // ---------------------------
    // MARK: - Getters and Setters
    // ---------------------------

    public var backgroundView: UIView {
        get {
            if let subView = viewWithTag(btnBackgroundTag) {
                return subView
            }
            
            return UIView(frame: CGRect())
        }
    }
}
