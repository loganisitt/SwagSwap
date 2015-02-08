//
//  ImageCell.swift
//  SwagSwap
//
//  Created by Logan Isitt on 2/5/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.imageView = UIImageView(frame: self.bounds)
    }
}