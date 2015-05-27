//
//  Watch.swift
//  swagswap
//
//  Created by Logan Isitt on 4/21/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

class Watch: PFObject, PFSubclassing {
    
    @NSManaged var watcher: PFUser!
    @NSManaged var listing: Listing!
    
    override class func initialize() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "Watch"
    }
}