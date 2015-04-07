//
//  InboxCell.swift
//  swagswap
//
//  Created by Logan Isitt on 4/7/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    @IBOutlet var userImgView: PFImageView!
    
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var lastMessage: UILabel!

    @IBOutlet var timestamp: UILabel!
    
    var file: PFFile! {
        willSet(newFile) {
            
        }
        didSet {
            userImgView.file = file
            userImgView.loadInBackground()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImgView.layer.cornerRadius = userImgView.frame.width / 2
        userImgView.clipsToBounds = true
        
        userNameLbl.minimumScaleFactor = 0.75
        userNameLbl.adjustsFontSizeToFitWidth = true
    }
}