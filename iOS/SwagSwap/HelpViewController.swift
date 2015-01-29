//
//  HelpViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/29/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
        self.title = "Help"
        self.navigationItem.title = self.title
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 206.0/255.0, green: 0, blue: 43.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 32)!]
    }
}