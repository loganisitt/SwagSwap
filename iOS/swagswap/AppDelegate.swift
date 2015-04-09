//
//  AppDelegate.swift
//  swagswap
//
//  Created by Logan Isitt on 2/25/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegatesys
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        Message.registerSubclass()
        Message()
        
        Parse.setApplicationId("FYYc6l6Fi8XTNiH0lybpzsob6tZcTd8luLDiZR1l", clientKey: "smiuvnfGa8CW8H5radVT8TZcy7OOU3HR4PrWIOgF")

        PFFacebookUtils.initializeFacebook() // WithApplicationLaunchOptions(launchOptions)
        PFUser.enableAutomaticUser()
        
        let userNotificationTypes = (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound)
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }
    
    func applicationWillTerminate(application: UIApplication) {
        PFFacebookUtils.session()!.close()
    }
    
    // MARK: - Push Notifications
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if application.applicationState == UIApplicationState.Inactive {

            PFPush.handlePush(userInfo)

            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        if application.applicationState == UIApplicationState.Active {
            
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("SSMessageReceivedNotification", object: nil, userInfo: userInfo)
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    // MARK: - Facebook SDK Integration
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }
}

