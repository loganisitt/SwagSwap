//
//  SSDashViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/26/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class DashViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIToolbarDelegate {
    
    var objects: [PFObject]!
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var optToolbar: UIToolbar!
    @IBOutlet var optionBar: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 
        objects = [];
        self.loadObjects()
        
        // Installation
        var installation: PFInstallation = PFInstallation.currentInstallation()
        installation.setValue(PFUser.currentUser()!.objectId, forKey: "userId")
        installation.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success == true {
                println("Sucess")
            }
            else {
                println("wtf")
            }
        }
        
        
        // Style
        self.navigationController?.navigationBar.hideHairline()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.SSColor.Red
        self.navigationController?.navigationBar.tintColor = UIColor.SSColor.White
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.SSFont.H3!, NSForegroundColorAttributeName: UIColor.SSColor.White]
        
        optToolbar.barTintColor = self.navigationController?.navigationBar.barTintColor
        optToolbar.translucent = false
        
        optionBar.tintColor = UIColor.SSColor.White
        optionBar.setTitleTextAttributes([NSFontAttributeName: UIFont.SSFont.P!], forState: UIControlState.Normal)
        optionBar.setTitleTextAttributes([NSFontAttributeName: UIFont.SSFont.P!], forState: UIControlState.Highlighted)
        
        self.navigationItem.title = "SWAGSWAP"
        
        var searchBtn: UIBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIconWithName("fa-search"), style: UIBarButtonItemStyle.Done, target: self, action: "searchButtonPressed")
        
        searchBtn.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(20)], forState: UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem  = searchBtn
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
    }
    
    // MARK: - Loading & Recieving
    
    func loadObjects() {
        
        self.objectsWillLoad()
        
        var query = PFQuery(className: "Listing")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
            
            self.objects = objects as! [PFObject]
            if (error != nil) {
                self.objectsDidLoad(nil)
            }
            else {
                self.objectsDidLoad(error)
            }
        }
    }
    
    func objectsWillLoad() {
        //
    }
    
    func objectsDidLoad(error: NSError?) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed() {
        self.performSegueWithIdentifier("gotoCreate", sender: self)
    }
    
    @IBAction func searchButtonPressed() {
        self.performSegueWithIdentifier("gotoSearch", sender: self)
    }
    
    // MARK: - TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: MenuCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MenuCell
        
        cell.menuItem = MenuCell.MenuItem(rawValue: indexPath.row)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: performSegueWithIdentifier("gotoBuy", sender: self); break
        case 1: performSegueWithIdentifier("gotoSell", sender: self); break
        case 2: performSegueWithIdentifier("gotoWatch", sender: self); break
        case 3: performSegueWithIdentifier("gotoInbox", sender: self); break
        default: break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UICollectionView Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: ListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ListingCell
        
        let obj = objects[indexPath.row]
        cell.imageView.file = (obj.objectForKey("images") as! [PFFile])[0] as PFFile
        cell.titleText.text = obj.objectForKey("name") as? String
        let p = obj.objectForKey("price") as! Double
        cell.priceText.text = "$\(p)"
        
        cell.imageView.loadInBackground()
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate 
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gotoListing", sender: self)
    }
    
    // MARK: - UIColectionView Flow Layout Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let height = collectionView.bounds.height - 20.0
        return CGSizeMake(height, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    // MARK: - UIToolbar Delegate 
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoListing" {
            let vc = segue.destinationViewController as! ListingViewController
            let index = collectionView.indexPathsForSelectedItems()[0].row
            vc.listing = objects[index!]   
        }
    }
}