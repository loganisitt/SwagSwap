//
//  SSCreateViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/28/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSCreateViewController: UIViewController,UIImagePickerControllerDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var nameField:    UITextField!
    @IBOutlet var priceField:   UITextField!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var descView:     UITextView!
    @IBOutlet var imgCollection: UICollectionView!
    @IBOutlet var addImgBtn:    UIButton!
    
    var imgArray: [UIImage]!
    
    // MARK: - View
    override func viewDidLoad() {
        
        self.navigationItem.title = "Create"

        imgArray = []
    }
    
    // MARK: - Actions
    @IBAction func addImage() {
        
        var imagePickerController: UIImagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        self.presentViewController(imagePickerController, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveListing() {
        
        if (!nameField.text.isEmpty && !categoryField.text.isEmpty && !priceField.text.isEmpty && !descView.text.isEmpty && imgArray.count > 0) {
            var listing: PFObject = PFObject(className: "Listing")
            
            listing.setValue(nameField.text, forKey: "name")
            listing.setValue(categoryField.text, forKey: "category")
            listing.setValue((priceField.text as NSString).doubleValue, forKey: "price")
            listing.setValue(descView.text, forKey: "description")
            
            var imageFiles: [PFFile] = []
            for img in imgArray {
                imageFiles.append(PFFile(data: UIImageJPEGRepresentation(img, 1)))
            }
            
            listing.setValue(imageFiles, forKey: "images")
            
            listing.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                
                println("Saved!")
                if (success) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
        else {
            println("poop")
        }
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
        
        var cell: SSImageCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as SSImageCell
        
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
        
        var cgImg = imgArray[indexPath.row].og_imageAspectScaledToAtMostHeight(collectionView.bounds.size.height).CGImage
        
        return CGSize(width: CGFloat(CGImageGetWidth(cgImg)), height: CGFloat(CGImageGetHeight(cgImg)))
    }
}