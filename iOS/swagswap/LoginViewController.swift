//
//  ViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/25/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class LoginViewController: PFLogInViewController, PFLogInViewControllerDelegate {
    
    // MARK: - Initialization

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        
        self.delegate = self
        self.facebookPermissions = []
        self.fields = PFLogInFields.Facebook | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten | PFLogInFields.UsernameAndPassword | PFLogInFields.SignUpButton
        
        var signupViewController = SignUpViewController()
        
        self.signUpController = signupViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        var sLogo = UILabel()
        sLogo.text = "SWAGSWAP"
        sLogo.textColor = UIColor.SSColor.White
        sLogo.textAlignment = NSTextAlignment.Center
        sLogo.font = UIFont.SSFont.H1
        sLogo.shadowOffset = CGSizeMake(1, 1)
        sLogo.shadowColor = UIColor.blackColor()
        
        self.logInView!.logo = sLogo

        self.logInView!.facebookButton!.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView!.facebookButton!.titleLabel?.font = UIFont.SSFont.H4

        self.logInView!.logInButton!.backgroundColor = UIColor.SSColor.Red
        self.logInView!.logInButton!.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView!.logInButton!.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        self.logInView!.logInButton!.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView!.logInButton!.titleLabel?.font = UIFont.SSFont.H4
        
        self.logInView!.signUpButton!.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView!.signUpButton!.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        self.logInView!.signUpButton!.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView!.signUpButton!.titleLabel?.font = UIFont.SSFont.H4
        self.logInView!.signUpButton!.layer.borderColor = UIColor.SSColor.White.CGColor
        self.logInView!.signUpButton!.layer.borderWidth = 4.0
        self.logInView!.signUpButton!.layer.cornerRadius = 4.0
        
        self.logInView!.passwordForgottenButton!.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView!.passwordForgottenButton!.titleLabel?.font = UIFont.SSFont.H5
        self.logInView!.passwordForgottenButton!.titleLabel?.shadowOffset = CGSizeMake(0, 4)
        self.logInView!.passwordForgottenButton!.titleLabel?.shadowColor = UIColor.blackColor()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "fake")
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var img = UIImage(named: "background")?.og_imageAspectScaledToAtLeastWidth(self.view.frame.width).og_imageWithAlpha().og_grayscaleImage()
        
        self.logInView!.backgroundColor = UIColor(patternImage: img!).colorWithAlphaComponent(0.6)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!) {
            self.performSegueWithIdentifier("gotoDash", sender: self)
        }
    }
    
    // MARK: - Delegate
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {

       if PFFacebookUtils.isLinkedWithUser(user) {
            let req = FBRequest.requestForMe()
            req.startWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    let userData: NSDictionary = result as! NSDictionary
                    
                    PFUser.currentUser()!.setValue(userData["id"], forKey:"facebookId")
                    PFUser.currentUser()!.setValue(userData["name"], forKey:"name")
                    
                    let id: String =  userData["id"] as! String
                    let picUrl = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
                    let urlRequest = NSURLRequest(URL: picUrl!)
                    
                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        
                        if error == nil && data != nil {
                            let file: PFFile = PFFile(data: data)
                            
                            PFUser.currentUser()!.setValue(file, forKey:"picture")
                            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                
                            })
                        }
                    })
                    
                }
            })
        }
        self.performSegueWithIdentifier("gotoDash", sender: self)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        // TODO:
        println("Error: \(error)")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        // TODO:
    }
    
    // MARK: - Fake
    
    func fake() {
        var userQuery: PFQuery = PFUser.query()!
        userQuery.whereKeyExists("email")
        userQuery.findObjectsInBackgroundWithBlock { (objs: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                var objects = objs as! [PFObject]
                if objects.count > 0 {
                    println("Randomly selecting from \(objects.count)")
                    
                    var limit: UInt32 = UInt32(objects.count)
                    var rand = Int(arc4random_uniform(limit))
                    
                    let user = objects[rand] as PFObject
                    
                    self.logInView!.usernameField!.text = user.valueForKey("email") as! String
                    self.logInView!.passwordField!.text = "password"
                }
            }
        }
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

