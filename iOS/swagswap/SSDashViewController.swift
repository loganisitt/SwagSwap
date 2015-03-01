//
//  SSDashViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/26/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSDashViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var objects: [PFObject]!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objects = [];
        
        // Style
        self.navigationController?.navigationBar.barTintColor = UIColor.SSColor.Red
        self.navigationController?.navigationBar.tintColor = UIColor.SSColor.White
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.SSFont.H4!, NSForegroundColorAttributeName: UIColor.SSColor.White]
                
        self.navigationItem.title = "Dash"
        
        self.collectionView?.backgroundColor = UIColor.SSColor.White
        
        self.loadObjects()
        
        var plusBtn: UIButton = UIButton.buttonWithType(UIButtonType.InfoDark) as UIButton
        plusBtn.addTarget(self, action: "addButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        plusBtn.frame = CGRectMake(self.view.bounds.width - 60, self.view.bounds.height - 60, 40, 40)
        self.view.addSubview(plusBtn)
        self.view.bringSubviewToFront(plusBtn)
        
        self.collectionView?.superview?.addSubview(plusBtn)
        
        self.navigationController?.view.addSubview(plusBtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadObjects()
    }
    
    // MARK: - Loading & Recieving
    
    func loadObjects() {

        self.objectsWillLoad()
        
        var query = PFQuery(className: "Listing")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            
            self.objects = objects as [PFObject]
            if (error != nil) {
                self.objectsDidLoad(nil)
            }
            else {
                self.objectsDidLoad(error)
            }
        }
    }
    
    func objectsWillLoad() {
        println("Just cause")
    }
    
    func objectsDidLoad(error: NSError?) {
        self.collectionView?.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed() {
        self.performSegueWithIdentifier("gotoCreate", sender: self)
    }
    
    // MARK: - Collection
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> SSListingCell {
        
        var cell: SSListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as SSListingCell
        
        var object = objects[indexPath.row]
        var price = object.valueForKey("price") as Double
        
        cell.titleText.text = object.valueForKey("name") as String!
        cell.priceText.text = "$\(price)"
        
        cell.imageView.file = (object.valueForKey("images") as [PFFile])[0]
        
        cell.imageView.loadInBackground()
        
        cell.backgroundColor = UIColor.SSColor.White
        
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
        
        var width = ((UIScreen.mainScreen().bounds.size.width - 10) / 2.0) - 2.5
        
        // Hard coded
        return CGSize(width: width, height: width)
    }

}