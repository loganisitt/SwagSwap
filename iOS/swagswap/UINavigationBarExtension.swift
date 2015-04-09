//
//  UINavigationBarExtension.swift
//  swagswap
//
//  Created by Logan Isitt on 3/5/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func hideHairline() {
        if let hairlineView: UIImageView = self.findHairlineImageView(containedIn: self) {
            hairlineView.hidden = true
        }
    }
    
    func findHairlineImageView(containedIn view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            if let imageView: UIImageView = self.findHairlineImageView(containedIn: subview as! UIView) {
                return imageView
            }
        }
        
        return nil
    }
}