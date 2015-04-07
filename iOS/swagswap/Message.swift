//
//  Message.swift
//  swagswap
//
//  Created by Logan Isitt on 4/6/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

class Message : PFObject, PFSubclassing {
    
    @NSManaged var sender: PFUser!
    @NSManaged var recipient: PFUser!
    @NSManaged var content: String!
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
}