//
//  Client.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Alamofire

class Client {
    
    var baseUrl = "http://localhost:8080"
    
    class var sharedInstance: Client {
        struct Singleton {
            static let instance = Client()
        }
        return Singleton.instance
    }
    
    func signinWithFacebook(accessToken: String) -> Bool {
        
        var url = baseUrl + "/auth/facebook?access_token=" + accessToken
        
        var isSignedIn: Bool = false
        
        Alamofire.request(.POST, url).responseJSON() {
            (_, _, data, error) in
            
        }
        return true
    }
    
    func createNewListing(packet: Dictionary<String, AnyObject>) -> Bool {
        // test!
        var parameters = ["userId":"abc123", "category": "Shoes", "name": "Old Navy", "description": "I am a short description", "price": 19.99]
        
        var url = baseUrl + "/api/listing"
        
        Alamofire.request(.POST, url, parameters: packet).responseJSON() {
            (_, _, data, error) in
            println(data)
            println(error)
        }
        return true
    }
}