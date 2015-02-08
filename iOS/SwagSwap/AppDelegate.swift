//
//  AppDelegate.swift
//  SwagSwap
//
//  Created by Logan Isitt on 12/14/14.
//  Copyright (c) 2014 loganisitt. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userId: String!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded {
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: false, completionHandler: {(session, state, error) -> Void in
                self.sessionStateChanged(session, state: state, error: error)
            })
        }
        return true
    }
    
    func sessionStateChanged(session:FBSession, state:FBSessionState, error:NSError?) {
        
        if session.state == FBSessionState.Open || session.state == FBSessionState.OpenTokenExtended {
            
            let fbToken = session.accessTokenData.accessToken as String
            
            if (Client.sharedInstance.signinWithFacebook(fbToken)) {
                self.pushMenuView()
            }
        }
    }

    
    private func pushMenuView() {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as HomeViewController
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as MenuViewController
        
        let homeNav: UINavigationController = UINavigationController(rootViewController: homeViewController)
        let menuNav: UINavigationController = UINavigationController(rootViewController: menuViewController)
        
        menuViewController.homeViewController = homeNav
        
        let slideMenuController = SlideMenuController(mainViewController:homeNav, leftMenuViewController: menuNav)
        
        self.window?.rootViewController?.presentViewController(slideMenuController, animated: true, completion: nil)
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
    }

    func applicationWillResignActive(application: UIApplication) {
      
    }

    func applicationDidEnterBackground(application: UIApplication) {
      
    }

    func applicationWillEnterForeground(application: UIApplication) {
      
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    // MARK: - Facebook 
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        var wasHandled = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        
        return wasHandled
    }
}

