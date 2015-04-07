//
//  SSInboxViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 4/6/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSInboxViewController: UITableViewController {
    
    var parseClassName: String!
    
    var uniqueUsers = [PFUser]()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setup()
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.parseClassName = "Message"
    }
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Inbox"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
        
        loadObjects()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Parse
    
    func loadObjects() {
        
        self.objectsWillLoad()
        
        var senderQuery = PFQuery(className: parseClassName)
        senderQuery.whereKey("sender", equalTo: PFUser.currentUser())
        
        var recipientQuery = PFQuery(className: parseClassName)
        recipientQuery.whereKey("recipient", equalTo: PFUser.currentUser())
        
        var query = PFQuery.orQueryWithSubqueries([senderQuery, recipientQuery])
        
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error != nil {
                println("ERROR: \(error)")
            }
            
            var messages = objects as [Message]
            
            let senders: [PFUser] = (messages as NSArray).valueForKeyPath("@distinctUnionOfObjects.sender") as [PFUser]
            
            let recipient: [PFUser] = (messages as NSArray).valueForKeyPath("@distinctUnionOfObjects.recipient") as [PFUser]
            
            var userIds = ((senders + recipient) as NSArray).valueForKeyPath("@distinctUnionOfObjects.objectId") as [String]
            userIds.removeObject(PFUser.currentUser().objectId)
            
            var userQuery = PFUser.query()
            userQuery.whereKey("objectId", containedIn: userIds)
            userQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                
                self.uniqueUsers = objects as [PFUser]
                
                if (error != nil) {
                    self.objectsDidLoad(nil)
                }
                else {
                    self.objectsDidLoad(error)
                }
            })
        }
    }
    
    
    func objectsWillLoad() {
        //
    }
    
    func objectsDidLoad(error: NSError?) {
        tableView.reloadData()
    }

    
    // MARK: - UITableView Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueUsers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: InboxCell = tableView.dequeueReusableCellWithIdentifier("Cell") as InboxCell
        
        if let imgFile = uniqueUsers[indexPath.row].valueForKey("picture") as? PFFile {
            cell.file = imgFile
        }
        
        cell.userNameLbl.text = uniqueUsers[indexPath.row].valueForKey("name") as? String
        cell.lastMessage.text = "Hey..."
        
        return cell
    }
}