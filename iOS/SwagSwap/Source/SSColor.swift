//
//  SSColor.swift
//  SwagSwap
//
//  Created by Logan Isitt on 2/4/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substringFromIndex(advance(hex.startIndex, 1))
        }
        
        if let match = hex.rangeOfString("(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .RegularExpressionSearch) {
            
            // Deal with 3 character Hex strings
            if countElements(hex) == 3 {
                var redHex   = hex.substringToIndex(advance(hex.startIndex, 1))
                var greenHex = hex.substringWithRange(Range<String.Index>(start: advance(hex.startIndex, 1), end: advance(hex.startIndex, 2)))
                var blueHex  = hex.substringFromIndex(advance(hex.startIndex, 2))
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = hex.substringToIndex(advance(hex.startIndex, 2))
            let greenHex = hex.substringWithRange(Range<String.Index>(start: advance(hex.startIndex, 2), end: advance(hex.startIndex, 4)))
            let blueHex = hex.substringWithRange(Range<String.Index>(start: advance(hex.startIndex, 4), end: advance(hex.startIndex, 6)))
            
            var redInt:   CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt:  CUnsignedInt = 0
            
            NSScanner(string: redHex).scanHexInt(&redInt)
            NSScanner(string: greenHex).scanHexInt(&greenInt)
            NSScanner(string: blueHex).scanHexInt(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }
        else {
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
    
    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init?(hex: Int, alpha: Float) {
        var hexString = NSString(format: "%2X", hex)
        self.init(hexString: hexString, alpha: alpha)
    }
    
    struct SSColor {
        static let Red          = UIColor(red: 206.0/255.0, green: 0, blue: 43.0/255.0, alpha: 1)
        static let Pink         = UIColor(hex: 0xE91E63)
        static let Purple       = UIColor(hex: 0x9C27B0)
        static let DeepPurple   = UIColor(hex: 0x67AB7)
        static let Indigo       = UIColor(hex: 0x3F51B5)
        static let Blue         = UIColor(hex: 0x2196F3)
        static let LightBlue    = UIColor(hex: 0x03A9F4)
        static let Cyan         = UIColor(hex: 0x00BCD4)
        static let Teal         = UIColor(hex: 0x009688)
        static let Green        = UIColor(hex: 0x4CAF50)
        static let LightGreen   = UIColor(hex: 0x8BC34A)
        static let Lime         = UIColor(hex: 0xCDDC39)
        static let Yellow       = UIColor(hex: 0xFFEB3B)
        static let Amber        = UIColor(hex: 0xFFC107)
        static let Orange       = UIColor(hex: 0xFF9800)
        static let DeepOrange   = UIColor(hex: 0xFF5722)
        static let Brown        = UIColor(hex: 0x795548)
        static let Grey         = UIColor(hex: 0x9E9E9E)
        static let BlueGrey     = UIColor(hex: 0x607D8B)
    }
}