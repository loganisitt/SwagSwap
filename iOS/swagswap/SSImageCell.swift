//
//  SSImageCell.swift
//  swagswap
//
//  Created by Logan Isitt on 3/1/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSImageCell: UICollectionViewCell {
    
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