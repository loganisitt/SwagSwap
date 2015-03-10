//
//  SSDashViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/26/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSFeedViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var name: UILabel!
    
    var pageIndex: Int?
    var titleText : String!
    var imageFile : PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.file = imageFile
        self.name.text = self.titleText
        self.name.alpha = 0.1
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.name.alpha = 1.0
        })
        
        self.imageView.loadInBackground { (img: UIImage!, error: NSError!) -> Void in
            var cgImg = img?.CGImage
            let height = CGFloat(CGImageGetHeight(cgImg))
            let width = CGFloat(CGImageGetWidth(cgImg))
            
            var vFrame = self.view.frame
            self.view.frame = CGRectMake(vFrame.origin.x, vFrame.origin.y, width, height)
            
            self.preferredContentSize = CGSizeMake(width, height)
            self
        }
    }
}