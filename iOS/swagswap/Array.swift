//
//  Array.swift
//  swagswap
//
//  Created by Logan Isitt on 4/7/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

extension Array {
    mutating func removeObject<T: Equatable>(object: T) {
        var index: Int?
        
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? T {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
    
    func unique<T : Equatable>(array: [T]) -> [T] {
        var result = [T]()
        for x in array {
            if !contains(result, x) {
                result.append(x)
            }
        }
        return result
    }
}