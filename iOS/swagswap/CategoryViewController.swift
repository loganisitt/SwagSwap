//
//  CategoryViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 4/19/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

protocol CategoryViewControllerDelegate {
    func selectedCategory(category: Category)
}

class CategoryViewController: UITableViewController, ExploreHeaderViewDelegate {
    
    var selectedSection: Int = -1
    
    var sectionTitles = [String]()
    var subSections = [[Category]]()
    
    var selected: Category!
    
    var delegate: CategoryViewControllerDelegate!
    
    // MARK: - Initialization
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        println("style")
        setup()
    }
    
    override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        println("nib")
        setup()
    }

    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        println("decoder")
        setup()
    }

    // MARK: - Setup
    
    func setup() {
        
        // Customize
        tableView.rowHeight = 40
        tableView.sectionFooterHeight = 0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Parse
        let query: PFQuery = PFQuery(className: "Category")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            let categories = objects as! [Category]
            
            self.sectionTitles = (categories as NSArray).valueForKeyPath("@distinctUnionOfObjects.category") as! [String]
            sort(&self.sectionTitles)
            
            for title in self.sectionTitles {
                
                let predicate = NSPredicate(format: "category==%@", title)
                
                let filtered = (categories as NSArray).filteredArrayUsingPredicate(predicate) as! [Category]
                
                let subCategories: [Category] = filtered.sorted({ (c1: Category, c2: Category) -> Bool in
                    //
                    return c1.subcategory < c2.subcategory
                })
                
                self.subSections.append(subCategories)
            }
        
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style
        navigationController?.navigationBar.hideHairline()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = UIColor.SSColor.Red
        navigationController?.navigationBar.tintColor = UIColor.SSColor.White
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.SSFont.H3!, NSForegroundColorAttributeName: UIColor.SSColor.White]
        
        self.navigationItem.title = "Categories"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("done"))

        // Register
        tableView.registerClass(ExploreHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.registerNib(UINib(nibName: "ExploreCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        selected = nil
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
    }
    
    @IBAction func done() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSection == section ? subSections[section].count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: ExploreCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ExploreCell
        
        let subcategory: Category = subSections[indexPath.section][indexPath.row] as Category
        cell.title.text = subcategory.subcategory
        cell.color = subcategory.color
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let category: Category = subSections[section][0] as Category
        
        let header: ExploreHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! ExploreHeaderView
        header.delegate = self

        header.titleText = category.category
        header.iconName = category.icon
        header.color = category.color
        
        header.section = section

        header.isExpanded = selectedSection == section
        
        header.contentView.backgroundColor = UIColor.whiteColor()
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selected = subSections[indexPath.section][indexPath.row] as Category
        
        if delegate != nil {
            delegate.selectedCategory(selected)
        }
    }
    
    // MARK: - ExploreHeaderViewDelegate
    
    func expandOrContractSection(section: Int) {
        
        if selectedSection == section { // Selected the same one, collapse
            selectedSection = -1
            
            tableView.beginUpdates()
            tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
        else {
            let lastSection = selectedSection
            selectedSection = section
            
            let set = NSMutableIndexSet(index: selectedSection)
            if lastSection != -1 {
                set.addIndex(lastSection)
            }
            
            tableView.beginUpdates()
            tableView.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: selectedSection), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
}