//
//  SSCreateViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/28/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit
import TextFieldEffects
import Toucan

class CreateViewController: UIViewController,UIImagePickerControllerDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var categoryViewController: CategoryViewController!

    @IBOutlet var nameField:  YokoTextField!
    @IBOutlet var priceField: YokoTextField!
    
    @IBOutlet var categoryField: UIButton!
    @IBOutlet var addImgBtn:    UIButton!
    
    @IBOutlet var descView: KMPlaceholderTextView!
    
    @IBOutlet var imgCollection: UICollectionView!
    
    var imgArray: [UIImage]!
    var category: Category!
    
    // MARK: - View
    override func viewDidLoad() {
        
        self.navigationItem.title = "Create"

        imgArray = []
        
        categoryField.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: "resignFirstResponders")
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("resignFirstResponders"))
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(downSwipe)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if categoryViewController != nil {
            if categoryViewController.selected != nil {
                category = categoryViewController.selected
                categoryField.backgroundColor = UIColor(rgba: categoryViewController.selected.color)
                categoryField.setTitle("\(categoryViewController.selected.category): \(categoryViewController.selected.subcategory)", forState: UIControlState.Normal)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func showImageSourcePicker() {
        
        var imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        
        let sourceAlertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            //
        }
    
        sourceAlertController.addAction(cancelAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            //
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        sourceAlertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        sourceAlertController.addAction(libraryAction)
        
        self.presentViewController(sourceAlertController, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func showCategoryViewController() {
        
        if (categoryViewController == nil) {
            categoryViewController = CategoryViewController()
        }
        
        let navController = UINavigationController(rootViewController: categoryViewController)
        
        navController.navigationBar.hideHairline()
        navController.navigationBar.translucent = false
        navController.navigationBar.barTintColor = UIColor.SSColor.Red
        navController.navigationBar.tintColor = UIColor.SSColor.White
        navController.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.SSFont.H3!, NSForegroundColorAttributeName: UIColor.SSColor.White]
        
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func resignFirstResponders() {
        
        for v in view.subviews {
            if v.isFirstResponder() {
                v.resignFirstResponder()
            }
        }
    }
    
    @IBAction func saveListing() {
        
        if (!nameField.text.isEmpty && !priceField.text.isEmpty && !descView.text.isEmpty && imgArray.count > 0 && categoryViewController.selected != nil) {
            var listing: PFObject = PFObject(className: "Listing")
            
            listing.setValue(nameField.text, forKey: "name")
            listing.setValue(category, forKey: "category")
            listing.setValue((priceField.text as NSString).doubleValue, forKey: "price")
            listing.setValue(descView.text, forKey: "desc")
            listing.setValue(PFUser.currentUser(), forKey: "seller")
            
            var imageFiles: [PFFile] = []
            for img in imgArray {
                imageFiles.append(PFFile(data: UIImageJPEGRepresentation(img, 0.80)))
                
                let mbs: Float = Float(NSData(data: UIImageJPEGRepresentation(img, 0.80)).length) / powf(1024, 2)
                println("Saving image of \(mbs)MBs")
            }
            
            listing.setValue(imageFiles, forKey: "images")
            
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
               
                listing.setValue(geoPoint, forKey: "location")
                
                listing.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                    
                    println("Saved!")
                    if (success) {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }
        else {
            
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let size = CGSizeMake(1024, 1024)
        
        let scaled: UIImage = RBResizeImage(tempImage, targetSize: size)
        
        imgArray.append(scaled)
        
        self.imgCollection.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        var cell: ImageCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCell
        
        cell.imageView.image = imgArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
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
        
        var cgImg = imgArray[indexPath.row].og_imageAspectScaledToAtMostHeight(collectionView.bounds.size.height).CGImage
        
        return CGSize(width: CGFloat(CGImageGetWidth(cgImg) - 10), height: CGFloat(CGImageGetHeight(cgImg) - 10))
    }
    
    // MARK: - Helper
    // TODO: Move into Extension
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}