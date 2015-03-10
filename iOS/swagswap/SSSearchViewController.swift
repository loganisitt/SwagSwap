//
//  SSSearchViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 3/3/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSSearchViewController: UIViewController, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.searchDisplayController?.searchBar.barTintColor = UIColor.SSColor.Red
        
        var img = UIImage().og_imageWithColor(UIColor.SSColor.Red)
        self.searchDisplayController?.searchBar.setBackgroundImage(img, forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        
        self.tableview.sectionFooterHeight = 0
        tableview.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Cars"
        case 1: cell.textLabel?.text = "Animals"
        case 2: cell.textLabel?.text = "Food"
        case 3: cell.textLabel?.text = "Clothes"
        case 4: cell.textLabel?.text = "Furniture"
        case 5: cell.textLabel?.text = "Tech"
        default: cell.textLabel?.text = ""
        }
        
        
        return cell
    }
}