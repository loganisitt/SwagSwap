//
//  ListingCell.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/28/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Haneke

class ListingCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: frame)
        self.label = UILabel(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.imageView = UIImageView(frame: self.bounds)
        self.label = UILabel(frame: self.bounds)
    }
}