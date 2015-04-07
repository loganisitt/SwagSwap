//
//  SSSearchViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/3/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate, SSExploreHeaderViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    var selectedSection: Int = -1
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
        
        var img = UIImage().og_imageWithColor(UIColor.SSColor.Red)
        searchDisplayController?.searchBar.setBackgroundImage(img, forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        
        tableview.registerClass(SSExploreHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        tableview.rowHeight = 40
        tableview.sectionHeaderHeight = 60
        tableview.sectionFooterHeight = 0
        tableview.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == selectedSection ? 3 : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header: SSExploreHeaderView = tableview.dequeueReusableHeaderFooterViewWithIdentifier("Header") as SSExploreHeaderView
        header.delegate = self
        header.exploreItem = SSExploreHeaderView.ExploreItem(rawValue: section)
        header.isExpanded = selectedSection == section
        header.contentView.backgroundColor = UIColor.whiteColor()
        
        return header
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: SSExploreCell = tableView.dequeueReusableCellWithIdentifier("Cell") as SSExploreCell
        cell.exploreItem = SSExploreCell.ExploreItem(rawValue: indexPath.section)
        cell.title.text = "Item \(indexPath.row)"
        return cell
    }
    
    // SSExploreView Delegate
    func expandOrContractSection(section: Int) {
        
        if selectedSection == section { // Selected the same one, collapse
            selectedSection = -1
            self.tableview.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        else {
            let lastSection = selectedSection
            selectedSection = section
            
            let set = NSMutableIndexSet(index: selectedSection)
            if lastSection != -1 {
                set.addIndex(lastSection)
            }
            
            self.tableview.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}