//
//  SSSearchViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/3/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, ExploreHeaderViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
        
        tableView.registerClass(ExploreHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        tableView.rowHeight = 40
        tableView.sectionFooterHeight = 0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.definesPresentationContext = true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isSearching ? 1 : 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? search.count : section == selectedSection ? 3 : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            return nil
        }
        else {
            let header: ExploreHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! ExploreHeaderView
            header.delegate = self
            header.exploreItem = ExploreHeaderView.ExploreItem(rawValue: section)
            header.isExpanded = selectedSection == section
            header.contentView.backgroundColor = UIColor.whiteColor()
            
            return header
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isSearching {
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            cell.textLabel?.text = search[indexPath.row]["name"].string
            return cell
        }
        else {
            var cell: ExploreCell = tableView.dequeueReusableCellWithIdentifier("ECell") as! ExploreCell
            cell.exploreItem = ExploreCell.ExploreItem(rawValue: indexPath.section)
            cell.title.text = "Item \(indexPath.row)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 0 : 60
    }

    
    // SSExploreView Delegate
    
    func expandOrContractSection(section: Int) {
        
        if selectedSection == section { // Selected the same one, collapse
            selectedSection = -1
            tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        else {
            let lastSection = selectedSection
            selectedSection = section
            
            let set = NSMutableIndexSet(index: selectedSection)
            if lastSection != -1 {
                set.addIndex(lastSection)
            }
            tableView.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearching = true
        tableView.reloadData()
        searchBar.showsCancelButton = true
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
    }
    
//    optional func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
}