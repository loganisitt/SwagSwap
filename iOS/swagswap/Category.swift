//
//  Category.swift
//  swagswap
//
//  Created by Logan Isitt on 4/20/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import Parse

class Category : PFObject, PFSubclassing {
    
    @NSManaged var category: String!
    @NSManaged var subcategory: String!
    @NSManaged var icon: String!
    @NSManaged var color: String!
    
    override class func initialize() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "Category"
    }
}