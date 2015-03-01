//
//  ViewController.swift
//  swagswap
//
//  Created by Logan Isitt on 2/25/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSLoginViewController: PFLogInViewController, PFLogInViewControllerDelegate {
    
    // MARK: - Initialization
    override init() {
        super.init()
        setup()
    }

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
        self.facebookPermissions = ["friends_about_me"]
        self.fields = PFLogInFields.Facebook | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten | PFLogInFields.UsernameAndPassword | PFLogInFields.SignUpButton
        
        var ssSignupViewController = SSSignUpViewController()
        
        self.signUpController = ssSignupViewController
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
        
        self.logInView.logo = sLogo

        self.logInView.facebookButton.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView.facebookButton.titleLabel?.font = UIFont.SSFont.H4

        self.logInView.logInButton.backgroundColor = UIColor.SSColor.Red
        self.logInView.logInButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.logInButton.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        self.logInView.logInButton.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView.logInButton.titleLabel?.font = UIFont.SSFont.H4
        
        self.logInView.signUpButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.signUpButton.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        self.logInView.signUpButton.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView.signUpButton.titleLabel?.font = UIFont.SSFont.H4
        self.logInView.signUpButton.layer.borderColor = UIColor.SSColor.White.CGColor
        self.logInView.signUpButton.layer.borderWidth = 4.0
        self.logInView.signUpButton.layer.cornerRadius = 4.0
        
        self.logInView.passwordForgottenButton.setTitleColor(UIColor.SSColor.White, forState: UIControlState.Normal)
        self.logInView.passwordForgottenButton.titleLabel?.font = UIFont.SSFont.P
        self.logInView.passwordForgottenButton.titleLabel?.shadowOffset = CGSizeMake(0, 4)
        self.logInView.passwordForgottenButton.titleLabel?.shadowColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var img = UIImage(named: "background")?.og_imageAspectScaledToAtLeastWidth(self.view.frame.width).og_imageWithAlpha().og_grayscaleImage()
        
        self.logInView.backgroundColor = UIColor(patternImage: img!).colorWithAlphaComponent(0.6)
    }
    
    // MARK: - Delegate
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        // TODO:
        // Can be used to require password of length 8 or something
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        // TODO:
        self.performSegueWithIdentifier("gotoDash", sender: self)
        
        println("You signed in!")
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        // TODO:
        println("Error: \(error)")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        // TODO:
    }
}

