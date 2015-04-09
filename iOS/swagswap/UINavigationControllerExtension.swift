//
//  UINavigationControllerExtension.swift
//  swagswap
//
//  Created by Logan Isitt on 3/5/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

extension UINavigationController {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
