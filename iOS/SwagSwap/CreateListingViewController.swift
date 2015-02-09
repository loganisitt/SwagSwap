//
//  CreateListingViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit
import Alamofire

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
        
        var imgLocations = saveLocally(imgArray)
        
        for img in imgArray {
            
            Client.sharedInstance.uploadImage(img)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveLocally(images: [UIImage]) -> [String] {
    
        let fileManager = NSFileManager.defaultManager()
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var urls = [] as [String]

        for var i = 0; i < images.count; i++ {
            
            var filePathToWrite = "\(paths)/image\(i).png"

            var imageData = UIImagePNGRepresentation(images[i])
            
            NSFileManager.defaultManager().createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
            
            fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
            
            var getImagePath = paths.stringByAppendingPathComponent("image\(i).png") as String
            
            urls.append(getImagePath)
        }
        
        return urls
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