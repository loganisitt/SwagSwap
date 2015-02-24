//
//  Client.swift
//  SwagSwap
//
//  Created by Logan Isitt on 1/27/15.
//  Copyright (c) 2015 loganisitt. All rights reserved.
//

import UIKit
import MobileCoreServices

import Alamofire
import SwiftyJSON

class Client {
        
    var baseUrl = "http://192.168.2.8:8080" // Dev
//    var baseUrl = "http://swagswap.me" // Pro
    
    var userID: String!
    var listings = [JSON]()
    
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
        return true
    }
    
    func basicSearchFor(query: String) -> Bool {
        
        var url = baseUrl + "/api/listing/search"
        
        var parameters = ["name": query]
        Alamofire.request(.GET, url, parameters: parameters ).validate().responseJSON() {
            (_, _, data, error) in
            
            if (data != nil) {
                var json = JSON(data!)
                
                println(json)
            }

        }
    
        return true
    }
    
    func getAllListings(){
        
        var urlString = baseUrl + "/api/listing"
        
        Alamofire.request(.GET, urlString).validate().responseJSON() {
            (_, _, data, error) in
            
            if (error != nil) {
                println(error)
            }
            
            self.listings = JSON(data!).array!
        }
    }
    
    func createNewListing(packet: Dictionary<String, AnyObject>, imgPaths: [String]) -> Bool{
        
        var urlString = baseUrl + "/api/listing"
        
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var fileManager = NSFileManager.defaultManager()
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        
        request.HTTPBody = createBodyWithParameters(packet, filePathKey: "file", paths: imgPaths, boundary: boundary)
        
        Alamofire.request(request)
            .validate()
            .progress {
            (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                
                println(totalBytesWritten)
            }
            .responseJSON() {
            (request, res, data, error) in
                
                if (error != nil) {
                    println(error)
                }
                println(data)
                
                for path in imgPaths {
                    if fileManager.fileExistsAtPath(path) {
                        fileManager.removeItemAtPath(path, error: nil)
                        println("Removed file at path: \(path)")
                    }
                }
        }
        return true
    }
    
    func createBodyWithParameters(parameters: [String: AnyObject]?, filePathKey: String?, paths: [String]?, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
    
        if paths != nil {
            for path in paths! {
                let filename = path.lastPathComponent
                let data = NSData(contentsOfFile: path)
                let mimetype = mimeTypeForPath(path)
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.appendData(data!)
                body.appendString("\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// :returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// :param: path         The path of the file for which we are going to determine the mime type.
    ///
    /// :returns:            Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as NSString
            }
        }
        return "application/octet-stream";
    }
}