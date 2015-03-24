//
//  SSListingViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/21/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSListingViewController: UITableViewController {
    
    var listing: PFObject!
    
    var imgIndex = 0
    
    // MARK: - Initialization
    override init() {
        super.init()
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        
    }
    
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Listing"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func nextImageSwipe() {
        let preChange = imgIndex
        let imageCount = listing.objectForKey("images").count
        println("Listing only has \(imageCount) images")
        
        imgIndex++
        
        if imgIndex >= listing.objectForKey("images").count {
            imgIndex = 0
        }
        
        if preChange != imgIndex {
            tableView.beginUpdates()
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Left)
            tableView.endUpdates()
        }
    }
    
    @IBAction func prevImageSwipe() {
        let preChange = imgIndex
        let imageCount = listing.objectForKey("images").count
        println("Listing only has \(imageCount) images")
        
        imgIndex--
        
        if imgIndex < 0 {
            imgIndex = imageCount - 1
        }
        
        if preChange != imgIndex {
            tableView.beginUpdates()
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Right)
            tableView.endUpdates()
        }
    }
    
    // MARK: UITableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : section == 1 ? 3 : 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: SSListingImageCell = tableView.dequeueReusableCellWithIdentifier("ImageCell") as SSListingImageCell
            cell.listingImageView.file = listing.objectForKey("images")[imgIndex] as PFFile
            
            
            let leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "nextImageSwipe")
            leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
            
            cell.addGestureRecognizer(leftSwipe)
            
            let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "prevImageSwipe")
            rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
            
            cell.addGestureRecognizer(rightSwipe)
            
            cell.listingImageView.loadInBackground()
            
            cell.imagesCount.currentPage = imgIndex
            cell.imagesCount.numberOfPages = listing.objectForKey("images").count
            cell.imagesCount.currentPageIndicatorTintColor = UIColor.SSColor.Blue
            cell.imagesCount.tintColor = UIColor.SSColor.LightBlue
            return cell
        }
        
        if indexPath.section == 1 {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell

            switch indexPath.row {
            case 0: cell.textLabel?.text = "Title"
            cell.detailTextLabel?.text = listing.valueForKey("name") as? String
            case 1: cell.textLabel?.text = "Price"
            let price = listing.valueForKey("price") as? Double
            cell.detailTextLabel?.text = "$\(price!)"
            case 2: cell.textLabel?.text = "Description"
            cell.detailTextLabel?.text = listing.valueForKey("desc") as? String
            default: cell.textLabel?.text = ""
            }
            
            return cell
        }
        else { //if indexPath.section == 2 {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell

            switch indexPath.row {
            case 0: cell.textLabel?.text = "Watch"
            case 1: cell.textLabel?.text = "Make offer"
            default: cell.textLabel?.text = ""
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Details" : ""
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ? "" : "1231 Views"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? view.frame.width : 44
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            if listing.valueForKey("seller") as PFUser == PFUser.currentUser() {
                return
            }
            
            var watch: PFObject = PFObject(className: "Watch")
            
            watch.setValue(PFUser.currentUser(), forKey: "watcher")
            watch.setValue(listing, forKey: "listing")
            
            watch.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                
            })
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            if listing.valueForKey("seller") as PFUser == PFUser.currentUser() {
                return
            }
            
            var offer: PFObject = PFObject(className: "Offer")
            
            offer.setValue(PFUser.currentUser(), forKey: "bidder")
            offer.setValue(listing, forKey: "listing")
            offer.setValue(Double(19.99), forKey: "Value")
            
            offer.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                
            })
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
