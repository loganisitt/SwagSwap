//
//  SSSignUpViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/26/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SignUpViewController: PFSignUpViewController, PFSignUpViewControllerDelegate {
   
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.emailAsUsername = true
        
        self.view.backgroundColor = UIColor.SSColor.Red
        
        var sLogo = UILabel()
        sLogo.text = "SWAGSWAP"
        sLogo.textColor = UIColor.SSColor.White
        sLogo.textAlignment = NSTextAlignment.Center
        sLogo.font = UIFont.SSFont.H1
        sLogo.shadowOffset = CGSizeMake(1, 1)
        sLogo.shadowColor = UIColor.blackColor()
        
        self.signUpView!.logo = sLogo
        
        self.signUpView!.signUpButton!.backgroundColor = UIColor.SSColor.Black
        self.signUpView!.signUpButton!.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.signUpView!.signUpButton!.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        self.signUpView!.signUpButton!.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.signUpView!.signUpButton!.titleLabel?.font = UIFont.SSFont.H4
        
        self.signUpView!.dismissButton!.tintColor = UIColor.SSColor.White
        self.signUpView!.dismissButton!.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        
        let fakeIt: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "fake")
        fakeIt.numberOfTapsRequired = 2
        view.addGestureRecognizer(fakeIt)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.bringSubviewToFront(self.signUpView!)
    }
    
    // MARK: - Delegate
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - FAKER
    
    func fake() {
//        let fakker = Faker()
        
//        signUpView!.usernameField!.text = fakker.email
        signUpView!.passwordField!.text = "password"
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
