//
//  MessageToolbar.swift
//  swagswap
//
//  Created by Logan Isitt on 4/8/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

protocol MessageToolbarDelegate: UIToolbarDelegate {
    func sendMessage(content: String)
    func scrollUp()
}


class MessageToolbar: UIToolbar {
    
    @IBOutlet var contentBarBtn: UIBarButtonItem!
    @IBOutlet var contentField: UITextField!
    @IBOutlet var sendBtn: UIBarButtonItem!
    
    @IBOutlet var frontSpacing: UIBarButtonItem!
    @IBOutlet var backSpacing: UIBarButtonItem!

    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: Selector("keyboardDidShow:"), name:UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: Selector("keyboardDidHide:"), name:UIKeyboardDidHideNotification, object: nil);
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buffer = CGFloat(8)
        
        sendBtn.width = 50
        contentBarBtn.width = frame.width - (sendBtn.width + (buffer * 3))
        
        frontSpacing.width = buffer - contentField.frame.origin.x
        backSpacing.width = frontSpacing.width
    }
    
    // MARK: - Actions
    @IBAction func sendAction() {
        (delegate as! MessageToolbarDelegate).sendMessage(contentField.text)
        contentField.text = ""
    }
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let convertedKeyboardEndFrame = convertRect(keyboardEndFrame, fromView: window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntValue << 16
        let animationCurve = UIViewAnimationOptions.init(UInt(rawAnimationCurve))
        
        self.bottomConstraint.constant = CGRectGetMaxY(bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
        
        self.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let convertedKeyboardEndFrame = convertRect(keyboardEndFrame, fromView: window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntValue << 16
        let animationCurve = UIViewAnimationOptions.init(UInt(rawAnimationCurve))
        
        self.bottomConstraint.constant = 0
        
        self.layoutIfNeeded()
    }
    
    func keyboardDidShow(notification: NSNotification) {
        (delegate as! MessageToolbarDelegate).scrollUp()
    }
    
    
    func keyboardDidHide(notification: NSNotification) {
        (delegate as! MessageToolbarDelegate).scrollUp()
    }
}