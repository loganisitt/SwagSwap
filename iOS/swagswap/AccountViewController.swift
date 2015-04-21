//
//  AccountViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 4/21/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    // MARK: - UITableView Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        cell.textLabel?.text = "Sign Out"
        cell.textLabel?.font = UIFont.SSFont.H3
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
