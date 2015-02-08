//
//  CreateListingViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit
import Alamofire

import Cartography

class CreateListingViewController: UIViewController, UIImagePickerControllerDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet var nameField:    MKTextField!
    @IBOutlet var priceField:   MKTextField!
    @IBOutlet var categoryField: MKTextField!
    @IBOutlet var descView:     SSTextView!
    @IBOutlet var imgCollection: UICollectionView!
    @IBOutlet var addImgBtn:    MKButton!
    
    var imgArray: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Create Listing"
        self.navigationItem.title = self.title
        
        imgArray = []
        
        // No border, no shadow, floatingPlaceholderEnabled
        nameField.layer.borderColor = UIColor.clearColor().CGColor
        nameField.floatingPlaceholderEnabled = true
        nameField.placeholder = "Name"
        nameField.tintColor = UIColor.SSColor.Red
        nameField.rippleLocation = .Right
        nameField.cornerRadius = 0
        nameField.bottomBorderEnabled = true
        nameField.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        // No border, no shadow, floatingPlaceholderEnabled
        priceField.layer.borderColor = UIColor.clearColor().CGColor
        priceField.floatingPlaceholderEnabled = true
        priceField.placeholder = "Price"
        priceField.tintColor = UIColor.SSColor.Red
        priceField.rippleLocation = .Right
        priceField.cornerRadius = 0
        priceField.bottomBorderEnabled = true
        priceField.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        // No border, no shadow, floatingPlaceholderEnabled
        categoryField.layer.borderColor = UIColor.clearColor().CGColor
        categoryField.floatingPlaceholderEnabled = true
        categoryField.placeholder = "Category"
        categoryField.tintColor = UIColor.SSColor.Red
        categoryField.rippleLocation = .Right
        categoryField.cornerRadius = 0
        categoryField.bottomBorderEnabled = true
        categoryField.font = UIFont(name: "Montserrat-Regular", size: 14)

        descView.layer.borderColor = UIColor.clearColor().CGColor
        descView.placeholder = "Description"
        descView.tintColor = UIColor.SSColor.Red
        descView.bottomBorderEnabled = true
        
        addImgBtn.setTitle("Add Pictures", forState: UIControlState.Normal)
        addImgBtn.layer.shadowOpacity = 0.55
        addImgBtn.layer.shadowRadius = 5.0
        addImgBtn.layer.shadowColor = UIColor.grayColor().CGColor
        addImgBtn.layer.shadowOffset = CGSize(width: 0, height: 2.5)
    
        var closeBtn: UIBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIconWithName("fa-close"), style: UIBarButtonItemStyle.Done, target: self, action: "cancel")

        closeBtn.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(30)], forState: UIControlState.Normal)
        
        var doneBtn: UIBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIconWithName("fa-check"), style: UIBarButtonItemStyle.Done, target: self, action: "done")
        
        doneBtn.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(30)], forState: UIControlState.Normal)
        
        self.navigationItem.leftBarButtonItem   = closeBtn
        self.navigationItem.rightBarButtonItem  = doneBtn
        
        var tapDismiss = UITapGestureRecognizer(target: self, action: "findAndResignFirstResponder")
        self.view.addGestureRecognizer(tapDismiss)
        
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        layout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        layout()
    }
    
    func findAndResignFirstResponder() {
        if self.isFirstResponder() {
            self.resignFirstResponder()
        }
        for subview in self.view.subviews {
            if subview.isFirstResponder() {
                subview.resignFirstResponder()
            }
        }
    }
    
    func layout() {
        
        println("Laying out views")
        
        let padding = UIEdgeInsetsMake(20, 20, 20, 20)
        let space = 8
        
        let blockHeight = (self.view.bounds.height - ( (padding.top + padding.bottom) + (5 * 8) ) ) / 10
        println("\tHEIGHT: \(blockHeight)")
        let blockWidth = self.view.bounds.width - (2 * padding.top)
        println("\tWIDTH: \(blockWidth)")
        
        println("VIEW: \(NSStringFromCGRect(self.view.frame))")
        
        var y = padding.top
        
        nameField.frame     = CGRectMake(padding.left, y, blockWidth, blockHeight)
        println("nameField: \(NSStringFromCGRect(self.nameField.frame))")
        
        y = CGRectGetMaxY(nameField.frame) + CGFloat(space)
        categoryField.frame = CGRectMake(padding.left, y, blockWidth, blockHeight)
        println("categoryField: \(NSStringFromCGRect(self.categoryField.frame))")
        
        y = CGRectGetMaxY(categoryField.frame) + CGFloat(space)
        priceField.frame    = CGRectMake(padding.left, y, blockWidth, blockHeight)
        println("priceField: \(NSStringFromCGRect(self.priceField.frame))")
        
        y = CGRectGetMaxY(priceField.frame) + CGFloat(space)
        descView.frame      = CGRectMake(padding.left, y, blockWidth, blockHeight)
        println("descView: \(NSStringFromCGRect(self.descView.frame))")
        
        y = CGRectGetMaxY(descView.frame) + CGFloat(space)
        imgCollection.frame = CGRectMake(padding.left, y, blockWidth, blockHeight)
        println("imgCollection: \(NSStringFromCGRect(self.imgCollection.frame))")
        
        y = imgCollection.frame.origin.y + imgCollection.frame.size.height + CGFloat(space)
        println("Y: \(y)")
        self.addImgBtn.frame     = CGRectMake(padding.left, y, blockWidth, blockHeight)
        println("addImgBtn: \(NSStringFromCGRect(self.addImgBtn.frame))")
        
        constrain(priceField) { priceField in
            priceField.width  == 100
            priceField.height == 100
            priceField.center == priceField.superview!.center
        }

    }
    
    @IBAction func addImage() {
        
        var imagePickerController: UIImagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        self.presentViewController(imagePickerController, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func done() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        imgArray.append(tempImage)
        
        self.imgCollection.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        var cell: ImageCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ImageCell
        
        cell.imageView.image = imgArray[indexPath.row]
        
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width - 2.5, height: collectionView.bounds.size.height - 2.5)
    }

}