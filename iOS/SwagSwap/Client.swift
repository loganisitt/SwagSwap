//
//  Client.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class Client {
    
    var baseUrl = "http://localhost:8080"
    
    var userID: String!
    
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
            
            if (data != nil) {
                var json = JSON(data!)
                
                self.userID = json["facebook"]["id"].string
            }
        }
        
        println("UserID: \(self.userID)")
        
        return true
    }
    
    func uploadImage(img: UIImage) -> String{
        var imgData = UIImagePNGRepresentation(img)
        
        var str = "displayImage"
        
        var urlString = baseUrl + "/api/listing/image"
        
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.HTTPShouldHandleCookies = false
        request.timeoutInterval = 30
        request.HTTPMethod = "POST"
        
        var boundary = "---------------------------14737809831464368775746641449"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = NSMutableData()
        
        body.appendData(NSString(string: "\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "Content-Disposition: form-data; name=\"currentEventID\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "52344457901000006").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        if (imgData != nil) {
            body.appendData(NSString(string: "\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)

            body.appendData(NSString(string: "Content-Disposition: form-data; name=\"\(str)\"; filename=\"image.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData(NSString(string: "Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imgData)
            body.appendData(NSString(string: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        body.appendData(NSString(string: "\r\n--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)

        request.HTTPBody = body
        
//        var bodyStr = NSString(data: body, encoding:NSUTF8StringEncoding)
//        println(bodyStr)
        
//        var lot_connection = NSURLConnection(request: request, delegate: self)
        
//        var url = "http://localhost:1337/upload" //baseUrl + "http://localhost:1337/upload"
        
//        var response: String!
        
        Alamofire.request(request).validate().responseJSON() {
            (request, _, data, error) in
            println(request)
            println(data)
            println(error)
        }
        
//        Alamofire.upload(.POST, url, imgData).validate().responseJSON() {
//            (request, _, data, error) in
//            println(request)
//            println(data)
//            println(error)
//        }
        
        return "Hello"
    }
    
    func createNewListing(packet: Dictionary<String, AnyObject>) -> Bool {
        
        var url = baseUrl + "/api/listing"
        
        Alamofire.request(.POST, url, parameters: packet).responseJSON() {
            (_, _, data, error) in
            println(data)
            println(error)
        }
        return true
    }
}