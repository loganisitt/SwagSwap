//
//  CreateListingViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit
import Alamofire

class CreateListingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var parameters = ["userId":"abc123", "category": "Shoes", "name": "Old Navy", "description": "I am a short description", "price": 19.99]
        
        Client.sharedInstance.createNewListing(parameters)
    }
}