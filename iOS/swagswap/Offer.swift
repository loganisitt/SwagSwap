//
//  Offer.swift
//  swagswap
//
//  Created by Logan Isitt on 4/20/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import Parse

class Offer : PFObject, PFSubclassing {
    
    @NSManaged var bidder: PFUser!
    @NSManaged var listing: Listing!
    @NSManaged var value: NSNumber!
    
    override class func initialize() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "Offer"
    }
}