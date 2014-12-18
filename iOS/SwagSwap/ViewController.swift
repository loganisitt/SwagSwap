//
//  ViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 12/14/14.
//  Copyright (c) 2014 loganisitt. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController, FBLoginViewDelegate, SocketIODelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
    }
    
    @IBAction func facebookLoginAction(sender: UIButton) {
        // If the session state is any of the two "open" states when the button is clicked
        if FBSession.activeSession().state == FBSessionState.Open || FBSession.activeSession().state == FBSessionState.OpenTokenExtended {
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            FBSession.activeSession().closeAndClearTokenInformation();
                
            
        }
        // If the session state is not any of the two "open" states when the button is clicked
        else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: { (session, state, error) -> Void in
                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.sessionStateChanged(session, state: state, error: error)
            })
        }
    }
    
    @IBAction func getTodos() {
        Alamofire.request(.GET, "http://localhost:8080/api/todos/").responseJSON() {
            (_, _, data, _) in
            println(data)
        }
    }
    
    @IBAction func postTodo() {
        
        var fbAccessToken = ""
//        var url = "http://localhost:3000/api/auth/facebook?access_token=CAAKjqepMlzEBAPYN0UXZAzkzLVQih1ZC9QdZB1x3THu9Dzdh8gtrtWPT3JoBihkSOuHR0v3ReErfWt7LGGpZCarEwHr2KKDAQZBmc3QLzgZBIDL2T31KNVOXsizXj3St8ZBA1tbiZAu4orDgAZChaQl4BiEskpu9d00tnB9RZBCQx13Ge8hrepM0Hk2g6YxZB8V7XS0zRqFGtKenRmumgXIJ2v1ZCZAhPsRoe2cy3YbC1tOv9jwZDZD"
        
        
        
        let parameters = [
            "access_token": "CAAKjqepMlzEBAPYN0UXZAzkzLVQih1ZC9QdZB1x3THu9Dzdh8gtrtWPT3JoBihkSOuHR0v3ReErfWt7LGGpZCarEwHr2KKDAQZBmc3QLzgZBIDL2T31KNVOXsizXj3St8ZBA1tbiZAu4orDgAZChaQl4BiEskpu9d00tnB9RZBCQx13Ge8hrepM0Hk2g6YxZB8V7XS0zRqFGtKenRmumgXIJ2v1ZCZAhPsRoe2cy3YbC1tOv9jwZDZD"
            ] as Dictionary
        
        var url = "http://localhost:1337/auth/facebook/token"
        
        
//        var url: NSURL = NSURL(string: NSString(format: "http://localhost:3000/api/auth/facebook?access_token=%@", fbAccessToken))! // WORKS
        

        
        
        // Todo App
//        Alamofire.request(.POST, "http://localhost:8080/api/todos/", parameters: parameters, encoding: .JSON).responseJSON() {
//            (_, _, data, _) in
//            println(data)
//        }
        // swagswap App
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON).responseString() {
            (_, _, data, _) in
            println(data)
        }
    
        
//        curl -X POST \
//        -d "email=niftylettuce%2Beskimo@gmail.com" \
//        -d "name=Nifty" \
//        -d "surname=Lettuce" \
//        -d "password=123456" \
//        "http://localhost:3000/api/auth/signup"
        
//        let parameters = [
//            "email": "hellooooo@logan.com",
//            "name": "nifty",
//            "surname": "Lettuce",
//            "password": "123456"
//            ] as Dictionary
//
//        Alamofire.request(.POST, "http://localhost:3000/api/auth/signup", parameters: parameters, encoding: .JSON).responseJSON() {
//            (_, _, data, _) in
//            println(data)
//        }
        
        
        
//        let parameters = [
//            "name": "nifty"
//            ] as Dictionary
//        
//        Alamofire.request(.GET, "http://localhost:3000/api/users/").responseJSON() {
//            (_, _, data, _) in
//            println(data)
//        }

        
    }
}

