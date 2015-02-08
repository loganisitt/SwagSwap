//
//  SSTextView.swift
//  SwagSwap
//
//  Created by Logan Isitt on 2/4/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit
import QuartzCore

import Snap

@IBDesignable
class SSTextView : UIView, UITextViewDelegate {
    
    private var textView: UITextView!
    private var bottomBorderLayer: CALayer?
    
    var textColor: UIColor = UIColor.blackColor()

    var bottomBorderWidth: CGFloat = 1.0
    var bottomBorderHighlightWidth: CGFloat = 1.75
    var bottomBorderColor: UIColor = UIColor.SSColor.Grey!
    
    var text: String!
    var placeholder: String! = "" {
        didSet {
            textView.text = placeholder
        }
    }
    
    var minHeight: CGFloat!
    
    var  heightConstraint:NSLayoutConstraint?

    
    var bottomBorderEnabled: Bool = true {
        didSet {
            bottomBorderLayer?.removeFromSuperlayer()
            bottomBorderLayer = nil
            if bottomBorderEnabled {
                bottomBorderLayer = CALayer()
                bottomBorderLayer?.frame =
                    CGRect(x: 0, y: self.frame.height - bottomBorderWidth, width: self.frame.width, height: bottomBorderWidth)
                bottomBorderLayer?.backgroundColor = bottomBorderColor.CGColor
                self.layer.addSublayer(bottomBorderLayer)
            }
        }
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        self.textView = UITextView(frame: self.bounds)
        self.textView.delegate = self
        self.addSubview(self.textView)
        
        textView.text = self.placeholder
        textView.textColor = UIColor.lightGrayColor()
        textView.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        for constraint in self.constraints() {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                self.heightConstraint = constraint as? NSLayoutConstraint;
                break;
            }
        }
        
        let padding = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textView.frame = self.bounds
        
        minHeight = min(self.textView.contentSize.height, self.textView.bounds.size.height)
        
        self.heightConstraint?.constant = minHeight
    
        bottomBorderLayer?.backgroundColor = self.textView.isFirstResponder() ? self.tintColor.CGColor : bottomBorderColor.CGColor
        let borderWidth = self.isFirstResponder() ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: minHeight - borderWidth, width: self.layer.bounds.width, height: borderWidth)
    }
    
    // MARK: - UITextView Delegate
    
    func textViewDidBeginEditing(textView: UITextView){
        
        bottomBorderLayer?.backgroundColor = self.tintColor.CGColor

        if (textView.text == placeholder){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {

        bottomBorderLayer?.backgroundColor = bottomBorderColor.CGColor

        if (textView.text == "") {
            textView.text = self.placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if minHeight != min(self.textView.contentSize.height, self.textView.bounds.size.height) {
            minHeight = min(self.textView.contentSize.height, self.textView.bounds.size.height)
            let borderWidth = self.isFirstResponder() ? bottomBorderHighlightWidth : bottomBorderWidth
            
            bottomBorderLayer?.frame =
                CGRect(x: 0, y: minHeight - borderWidth, width: self.layer.bounds.width, height: borderWidth)

        }
        return true
    }
    
    // MARK: - Behavior
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    override func isFirstResponder() -> Bool {
        return textView.isFirstResponder()
    }
}