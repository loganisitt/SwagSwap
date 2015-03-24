//
//  UIBarButtonItemExtension.swift
//  swagswap
//
//  Created by Logan Isitt on 3/10/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func SSBackButton(selector: Selector, target: AnyObject) -> UIBarButtonItem {
        self.title = String.fontAwesomeIconWithName("fa-chevron-left")
        self.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(20)], forState: UIControlState.Normal)
        self.target = target
        self.action = selector
        return self
    }
}
