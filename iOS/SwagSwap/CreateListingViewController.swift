//
//  CreateListingViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit
import Alamofire

class CreateListingViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var descView: UITextView!
    @IBOutlet var categoryBtn: UIButton!
    
    var imgArray: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var parameters = ["userId":"abc123", "category": "Shoes", "name": "Old Navy", "description": "I am a short description", "price": 19.99]
        
        Client.sharedInstance.createNewListing(parameters)
    }
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        imgArray.append(tempImage)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}