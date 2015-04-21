//
//  Listing.swift
//  swagswap
//
//  Created by Logan Isitt on 4/18/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import Parse

class Listing: PFObject, PFSubclassing {

    @NSManaged var seller: PFUser!
    
    @NSManaged var location: PFGeoPoint!
    
    @NSManaged var name: String!
    
    @NSManaged var category: String!
    
    @NSManaged var desc: String!
    
    @NSManaged var images: [PFFile]!
    
    @NSManaged var price: NSNumber!
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Listing"
    }
}

