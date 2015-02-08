//
//  MenuViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/28/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Alamofire

enum MenuView: Int {
    case Home = 0
    case Browse
    case Watching
    case Account
    case Inbox
    case Settings
    case Help
    case SignOut
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var menu = ["Home", "Browse", "Watching", "Account", "Inbox", "Settings", "Help", "SignOut"]
    
    var homeViewController: UIViewController!
    var browseViewController: UIViewController!
    var watchViewController: UIViewController!
    var accountViewController: UIViewController!
    var inboxViewController: UIViewController!
    var settingsViewController: UIViewController!
    var helpViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Name the view
        self.title = "SWAGSWAP"
        self.navigationItem.title = self.title
        
        // Styles nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 11.0/255.0, green: 81.0/255.0, blue: 84.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 32)!]
        
        // Stops empty cells from showing
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        // Setting up view controllers
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let browseViewController = storyboard.instantiateViewControllerWithIdentifier("BrowseViewController") as BrowseViewController
        self.browseViewController = UINavigationController(rootViewController: browseViewController)
        
        let watchViewController = storyboard.instantiateViewControllerWithIdentifier("WatchViewController") as WatchViewController
        self.watchViewController = UINavigationController(rootViewController: watchViewController)
        
        let accountViewController = storyboard.instantiateViewControllerWithIdentifier("AccountViewController") as AccountViewController
        self.accountViewController = UINavigationController(rootViewController: accountViewController)
        
        let inboxViewController = storyboard.instantiateViewControllerWithIdentifier("InboxViewController") as InboxViewController
        self.inboxViewController = UINavigationController(rootViewController: inboxViewController)
        
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as SettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController)
        
        let helpViewController = storyboard.instantiateViewControllerWithIdentifier("HelpViewController") as HelpViewController
        self.helpViewController = UINavigationController(rootViewController: helpViewController)
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

        cell.textLabel?.text = menu[indexPath.row]
        cell.imageView?.image = UIImage(named: menu[indexPath.row].lowercaseString)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.backgroundColor = UIColor.clearColor()
        cell.imageView?.tintColor = UIColor.whiteColor()
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = MenuView(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(menu: MenuView) {
        switch menu {
        case .Home:
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
        case .Browse:
            self.slideMenuController()?.changeMainViewController(self.browseViewController, close: true)
            break
        case .Watching:
            self.slideMenuController()?.changeMainViewController(self.watchViewController, close: true)
            break
        case .Account:
            self.slideMenuController()?.changeMainViewController(self.accountViewController, close: true)
            break
        case .Inbox:
            self.slideMenuController()?.changeMainViewController(self.inboxViewController, close: true)
            break
        case .Settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
            break
        case .Help:
            self.slideMenuController()?.changeMainViewController(self.helpViewController, close: true)
            break
        case .SignOut:
            println("TODO: Sign Out")
            break
        default:
            break
        }
    }
}