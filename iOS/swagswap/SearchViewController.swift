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

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var categoryViewController: CategoryViewController!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var index: ASRemoteIndex!
    var selectedSection: Int = -1
    
    var isSearching = false
    var search = [JSON]() {
        willSet(newData) {
            
        }
        didSet{
            if (searchBar.text as NSString).length == 0 {
                search = []
            }
            self.tableView.reloadData()
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
        
        
//        tableView.rowHeight = 40
//        tableView.sectionFooterHeight = 0
        
        addCategoryViewController()
        
        self.definesPresentationContext = true
    }
    
    func addCategoryViewController() {
        
        categoryViewController = CategoryViewController()
        addChildViewController(categoryViewController)
        
        view.addSubview(categoryViewController.tableView)
        
        let tv: UITableView = categoryViewController.tableView as UITableView
        
        layout(tv, searchBar) { view1, view2 in
            view1.top == view2.bottom
            view1.bottom == view1.superview!.bottom
            
            view1.width == view1.superview!.width
            
            view1.centerX == view1.superview!.centerX
        }
        
        categoryViewController.tableView.frame = tableView.bounds
        
        categoryViewController.didMoveToParentViewController(self)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.textLabel?.text = search[indexPath.row]["name"].string
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 0 : 60
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearching = true
        tableView.reloadData()
        searchBar.showsCancelButton = true
    
        view.bringSubviewToFront(tableView)
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchStr: String = searchBar.text
        
        println(searchStr)
        
        if (searchStr as NSString).length >= 3 {
            
            let query: ASQuery = ASQuery(fullTextQuery: searchStr)
            
            index.search(query, success: { (index: ASRemoteIndex!, query: ASQuery!, answers: [NSObject : AnyObject]!) -> Void in
                
                let json: JSON = JSON(answers) as JSON
                self.search = json["hits"].array!
                
                }, failure: nil)
        }
        else {
            self.search = []
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.search = []
        isSearching = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
        
        let tv: UITableView = categoryViewController.tableView as UITableView

        view.bringSubviewToFront(tv)
    }
    
//    optional func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
}