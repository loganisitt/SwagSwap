//
//  File.swift
//  swagswap
//
//  Created by Logan Isitt on 3/24/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit
import Toucan

class ListingImageCell: PFTableViewCell {
    
    @IBOutlet var listingImageView: PFImageView!
    
    var file: PFFile! {
        willSet(newFile) {
            
        }
        didSet {
            listingImageView.file = file
            listingImageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
                
                self.listingImageView.image = Toucan(image: image!).maskWithRoundedRect(cornerRadius: 5).image
            }
        }
    }
}

