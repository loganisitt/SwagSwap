//
//  SSSellViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/10/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SellViewController: PFQueryTableViewController {
   
    // MARK: - Initialization
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.parseClassName = "Listing"
    }
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Selling"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Parse
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Listing")
        query.whereKey("seller", equalTo: PFUser.currentUser()!)
        return query
    }
    
    // MARK: - UITableView Data Source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        let cell: PFTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell
        
        cell.textLabel?.text = object.valueForKey("name") as? String
        
        return cell
    }
}