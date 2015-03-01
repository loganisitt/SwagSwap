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
        static let H1       = UIFont(name: font, size: 50.0)
        static let H1_Bold  = UIFont(name: fontBold, size: 50.0)
        
        static let H2       = UIFont(name: font, size: 40.0)
        static let H2_Bold  = UIFont(name: fontBold, size: 40.0)
        
        static let H3       = UIFont(name: font, size: 25.0)
        static let H3_Bold  = UIFont(name: fontBold, size: 25.0)
        
        static let H4       = UIFont(name: font, size: 20.0)
        static let H4_Bold  = UIFont(name: fontBold, size: 20.0)
        
        static let P       = UIFont(name: font, size: 15.0)
        static let P_Bold  = UIFont(name: fontBold, size: 15.0)
    }
}