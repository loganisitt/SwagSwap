//
//  MenuViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/28/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Alamofire

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var menus = ["Main", "Swift", "Java", "Go", "NonMenu"]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SWAGSWAP"
        self.navigationItem.title = self.title
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 11.0/255.0, green: 81.0/255.0, blue: 84.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 32)!]
        
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Home"
            cell.imageView?.image = UIImage(named: "home")
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "Browse"
            cell.imageView?.image = UIImage(named: "browse")
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = "Watching"
            cell.imageView?.image = UIImage(named: "watching")
        }
        else if indexPath.row == 3 {
            cell.textLabel?.text = "Account"
            cell.imageView?.image = UIImage(named: "account")
        }
        else if indexPath.row == 4 {
            cell.textLabel?.text = "Inbox"
            cell.imageView?.image = UIImage(named: "inbox")
        }
        else if indexPath.row == 5 {
            cell.textLabel?.text = "Settings"
            cell.imageView?.image = UIImage(named: "settings")
        }
        else if indexPath.row == 6 {
            cell.textLabel?.text = "Help"
            cell.imageView?.image = UIImage(named: "help")
        }
        else if indexPath.row == 7 {
            cell.textLabel?.text = "Sign Out"
            cell.imageView?.image = UIImage(named: "signout")
        }

        cell.backgroundColor = UIColor.clearColor()
        cell.imageView?.image = cell.imageView?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.imageView?.tintColor = UIColor.whiteColor()
        
        return cell
    }
    
    // MARK: - Table View Delegate
}