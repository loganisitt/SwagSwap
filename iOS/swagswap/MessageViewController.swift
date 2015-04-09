//
//  MessageViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 4/7/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageToolbarDelegate {
    
    @IBOutlet var tableView: UITableView!
    let parseClassName = "Message"
    
    var mUser: PFUser!
    var tUser: PFUser!
    {
        willSet(newUser) {
            
        }
        didSet {
            loadMessages()
            self.navigationItem.title = tUser.valueForKey("name") as? String
        }
    }
    
    var messages = [Message]()
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem().SSBackButton("backButtonPressed", target: self)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("receivedMessage:"), name:"SSMessageReceivedNotification", object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadMessages() {
        mUser = PFUser.currentUser()
        
        var mQuery = PFQuery(className: parseClassName)
        mQuery.whereKey("sender", equalTo: mUser)
        mQuery.whereKey("recipient", equalTo: tUser)
        
        var tQuery = PFQuery(className: parseClassName)
        tQuery.whereKey("sender", equalTo: tUser)
        tQuery.whereKey("recipient", equalTo: mUser)
        
        var query = PFQuery.orQueryWithSubqueries([mQuery, tQuery])
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            self.messages = objects as! [Message]
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        cell.textLabel?.text = messages[indexPath.row].content
        cell.textLabel?.textAlignment = messages[indexPath.row].sender == mUser ? NSTextAlignment.Right : NSTextAlignment.Left
        
        return cell
    }
    
    // MARK: - Message Toolbar Delegate
    
    func sendMessage(content: String){
        var message: Message = Message()
        
        message.sender = mUser
        message.recipient = tUser
        message.content = content
        
        message.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if success == true {
                
                self.messages.append(message)
                
                let indexPath: NSIndexPath = NSIndexPath(forRow: self.messages.count-1, inSection: 0)
                
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.tableView.endUpdates()
                
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }
        })
    }
    
    func scrollUp() {

        let indexPath: NSIndexPath = NSIndexPath(forRow: self.messages.count-1, inSection: 0)

        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    // MARK: - Notifications
    
    func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        var message: Message = Message()
        
        message.sender = tUser
        message.recipient = mUser
        message.content = userInfo["content"] as! String

        self.messages.append(message)
        
        let indexPath: NSIndexPath = NSIndexPath(forRow: self.messages.count-1, inSection: 0)

        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
}
