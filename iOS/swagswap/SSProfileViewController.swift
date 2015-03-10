//
//  SSProfileViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/1/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import Foundation

class SSProfileViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.sectionFooterHeight = 0
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - TableView Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "Account & Settings"
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: cell.textLabel?.text = "Buying"
            case 1: cell.textLabel?.text = "Selling"
            case 2: cell.textLabel?.text = "Watching"
            case 3: cell.textLabel?.text = "Inbox"
            default: cell.textLabel?.text = ""
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: cell.textLabel?.text = "General"
            case 1: cell.textLabel?.text = "Notifications"
            case 2: cell.textLabel?.text = "Sign Out"
            default: cell.textLabel?.text = ""
            }
        }
        
        cell.detailTextLabel?.text = ""

        return cell
    }
}