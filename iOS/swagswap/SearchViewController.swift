//
//  SSSearchViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/3/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cartography

class SearchViewController: UIViewController, UISearchBarDelegate, CategoryViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categoryViewController: CategoryViewController!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!

    var index: ASRemoteIndex!
    var selectedSection: Int = -1
    
    var isSearching = false
    
    var listings: [Listing] = [Listing]() {
        didSet{
            if (searchBar.text as NSString).length == 0 {
                listings = []
            }
        }
    }
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Search" 
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
        
        var img = UIImage().og_imageWithColor(UIColor.SSColor.Red)
        
        let vc = UIViewController()
        
        searchBar.setBackgroundImage(img, forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        
        let apiClient = ASAPIClient.apiClientWithApplicationID("JS58CV0B5Y", apiKey: "c4a8bd50025f151ef367f7dfe71c81b4") as ASAPIClient
        index = apiClient.getIndex("listings") as ASRemoteIndex
        
        addCategoryViewController()
        
        self.definesPresentationContext = true
    }
    
    func addCategoryViewController() {
        
        categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
        
        addChildViewController(categoryViewController)
        
        view.addSubview(categoryViewController.tableView)
        
        let tv: UITableView = categoryViewController.tableView as UITableView
        
        layout(tv, searchBar) { view1, view2 in
            view1.top == view2.bottom
            view1.bottom == view1.superview!.bottom
            
            view1.width == view1.superview!.width
            
            view1.centerX == view1.superview!.centerX
        }
        
        categoryViewController.didMoveToParentViewController(self)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearching = true
        collectionView.reloadData()
        searchBar.showsCancelButton = true
    
        view.bringSubviewToFront(collectionView)
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchStr: String = searchBar.text
        
        if (searchStr as NSString).length >= 3 {
            
            let query: ASQuery = ASQuery(fullTextQuery: searchStr)
            
            index.search(query, success: { (index: ASRemoteIndex!, query: ASQuery!, answers: [NSObject : AnyObject]!) -> Void in
                
                let json: JSON = JSON(answers) as JSON
                let search = json["hits"].array!
                
                self.listings = []
                
                for s in search {
                    let objId: String = s["objectId"].string!
                    
                    PFQuery(className: "Listing").getObjectInBackgroundWithId(objId, block: { (obj: PFObject?, error: NSError?) -> Void in
                        self.listings.append(obj as! Listing)
                        
                        self.collectionView.reloadData()
                    })
                }
                
                }, failure: nil)
        }
        else {
            self.listings = []
            self.collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.listings = []
        isSearching = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        let tv: UITableView = categoryViewController.tableView as UITableView

        view.bringSubviewToFront(tv)
    }
    
//    optional func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    
    // MARK: - CategoryViewControllerDelegate
    
    func selectedCategory(category: Category) {
        self.performSegueWithIdentifier("gotoBrowse", sender: self)
    }
    
    // MARK: - UICollectionView Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: ListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ListingCell
        
        let listing: Listing = listings[indexPath.row] as Listing
        
        cell.imageView.file = listing.images[0]
        cell.titleText.text = listing.name
        cell.priceText.text = "$\(listing.price.doubleValue)"
        
        cell.imageView.loadInBackground()
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gotoListing", sender: self)
    }
    
    // MARK: - UIColectionView Flow Layout Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let height = collectionView.bounds.width / 2.0
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
    
    // MARK: - UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoListing" {
            let vc = segue.destinationViewController as! ListingViewController
            let index = collectionView!.indexPathsForSelectedItems()[0].row
            vc.listing = listings[index!]
        }
        
        if segue.identifier == "gotoBrowse" {
            let vc = segue.destinationViewController as! BrowseViewController
            vc.category = categoryViewController.selected
        }
    }
}

