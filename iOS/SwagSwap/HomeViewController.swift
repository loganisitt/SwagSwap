//
//  DashboardViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import Haneke

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()

        self.title = "Trending"
        self.navigationItem.title = self.title
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 206.0/255.0, green: 0, blue: 43.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 32)!]
        
        addButton.layer.shadowOpacity = 0.55
        addButton.layer.shadowRadius = 5.0
        addButton.layer.shadowColor = UIColor.grayColor().CGColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        addButton.cornerRadius = addButton.bounds.size.width / 2.0
        
        addButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        addButton.titleLabel?.textAlignment = NSTextAlignment.Center
        addButton.setTitle(String.fontAwesomeIconWithName("fa-plus"), forState: UIControlState.Normal)
        
        Client.sharedInstance.getAllListings()
        Client.sharedInstance.basicSearchFor("patio")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Client.sharedInstance.getAllListings()
        
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        println("COUNT: \(Client.sharedInstance.listings.count)")
        
        return Client.sharedInstance.listings.count > 0 ? Client.sharedInstance.listings.count : 0
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        var cell: ListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ListingCell

        if var path = Client.sharedInstance.listings[indexPath.row]["image_paths"][0].string {
            
            path = path.substringFromIndex(advance(path.startIndex, 8))
            
            let url = NSURL(string: Client.sharedInstance.baseUrl + path + "?dim=\(cell.imageView.bounds.width)")!
            
//            CIImage(contentsOfURL: url)
            cell.imageView.image = UIImage(CIImage: CIImage(contentsOfURL: url), scale: 1, orientation: UIImageOrientation.Up)
            
//            cell.imageView.hnk_setImageFromURL(url)
            println(cell.imageView.image?.imageOrientation)
        }
        else {
            cell.imageView.image = nil
        }
        
        cell.label.text = "\(indexPath.row)"
        
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
        
        var width = ((UIScreen.mainScreen().bounds.size.width - 10) / 2.0) - 2.5
        
        // Hard coded
        return CGSize(width: width, height: width)
    }
}