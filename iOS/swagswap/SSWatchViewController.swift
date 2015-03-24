//
//  SSWatchViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/10/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSWatchViewController: PFQueryTableViewController {
    
    // MARK: - Initialization
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.parseClassName = "Watch"
    }
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Watching"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Parse
    
    override func queryForTable() -> PFQuery! {
        var query = PFQuery(className: parseClassName)
        query.whereKey("watcher", equalTo: PFUser.currentUser())
        return query
    }
    
    // MARK: - UITableView Data Source
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cell: PFTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as PFTableViewCell
        
        cell.textLabel?.text = object.valueForKey("name") as? String
        
        let listing = object.objectForKey("listing") as PFObject
        
        cell.textLabel?.text = (object.objectForKey("listing") as PFObject).objectForKey("name") as? String
        
        return cell
    }
}