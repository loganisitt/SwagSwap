//
//  SSListingCell.swift
//  swagswap
//
//  Created by Logan Isitt on 2/28/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSListingCell: UICollectionViewCell {
    
    @IBOutlet var imageView: PFImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var priceText: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5.0
        clipsToBounds = true
        
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        
//        titleText.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
//        titleText.textColor = UIColor.SSColor.White
//        titleText.clipsToBounds = true
        
    }
}
