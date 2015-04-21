//
//  SSFont.swift
//  swagswap
//
//  Created by Logan Isitt on 2/26/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

extension UIFont {

    struct SSFont {
        private static let font     = "Montserrat-Regular"
        private static let fontBold = "Montserrat-Bold"
        
        private static let comp: CGFloat = UIScreen.mainScreen().bounds.size.width <= 320 ? 0 : 0
        
        static let H1       = UIFont(name: font, size: 50.0)?.fontWithSize(CGFloat(50.0 - comp))
        static let H1_Bold  = UIFont(name: fontBold, size: 50.0)?.fontWithSize(CGFloat(50.0 - comp))
        
        static let H2       = UIFont(name: font, size: 40.0)?.fontWithSize(CGFloat(40.0 - comp))
        static let H2_Bold  = UIFont(name: fontBold, size: 40.0)?.fontWithSize(CGFloat(40.0 - comp))
        
        static let H3       = UIFont(name: font, size: 25.0)?.fontWithSize(CGFloat(25.0 - comp))
        static let H3_Bold  = UIFont(name: fontBold, size: 25.0)?.fontWithSize(CGFloat(25.0 - comp))
        
        static let H4       = UIFont(name: font, size: 20.0)?.fontWithSize(CGFloat(20.0 - comp))
        static let H4_Bold  = UIFont(name: fontBold, size: 20.0)?.fontWithSize(CGFloat(20.0 - comp))
        
        static let H5       = UIFont(name: font, size: 16.0)?.fontWithSize(CGFloat(16.0 - comp))
        static let H5_Bold  = UIFont(name: font, size: 16.0)?.fontWithSize(CGFloat(16.0 - comp))
        
        static let H6       = UIFont(name: font, size: 12.00)?.fontWithSize(CGFloat(12.0 - comp))
        static let H6_Bold  = UIFont(name: font, size: 12.00)?.fontWithSize(CGFloat(12.0 - comp))

        static let P       = UIFont(name: font, size: 8.0)?.fontWithSize(CGFloat(8.0 - comp))
        static let P_Bold  = UIFont(name: fontBold, size: 8.0)?.fontWithSize(CGFloat(8.0 - comp))
    }
}