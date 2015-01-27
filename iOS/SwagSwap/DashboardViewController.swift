//
//  DashboardViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Alamofire

class DashboardViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dashboard"
        self.navigationItem.title = self.title
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Futura-Medium", size: 20)!]
    }
}