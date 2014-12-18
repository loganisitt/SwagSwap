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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SocketIODelegate {

    var window: UIWindow?
    
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
            
            print("DOING IT\n")
            let fbToken = session.accessTokenData.accessToken as String
            
            var url = "http://localhost:8080/auth/facebook"
            var url2 = "http://localhost:8080/auth/facebook?access_token=" + fbToken
            
            var tUrl = NSURL(string: url)
            var tUrl2 = NSURL(string:url2)
            
            let parameters = [
                "access_token": fbToken
                ] as Dictionary
            
            
//            Alamofire.request(.POST, url, parameters: parameters).responseJSON() {
//                (_, _, data, _) in
//                println(data)
//            }
            
            Alamofire.request(.POST, url2).responseJSON() {
                (_, _, data, error) in
                println(data)
                println(error)
            }
            
//            Alamofire.request(.POST, url, parameters: parameters).validate().responseJSON() {
//                (_, _, data, error) in
//                println(data)
//                println(error)
//            }
        }
        
        
//        if session.state == FBSessionState.Open {
//            
//            
//            
//            
//            let parameters = [
//                "access_token": "CAAKjqepMlzEBAPYN0UXZAzkzLVQih1ZC9QdZB1x3THu9Dzdh8gtrtWPT3JoBihkSOuHR0v3ReErfWt7LGGpZCarEwHr2KKDAQZBmc3QLzgZBIDL2T31KNVOXsizXj3St8ZBA1tbiZAu4orDgAZChaQl4BiEskpu9d00tnB9RZBCQx13Ge8hrepM0Hk2g6YxZB8V7XS0zRqFGtKenRmumgXIJ2v1ZCZAhPsRoe2cy3YbC1tOv9jwZDZD"
//                ] as Dictionary
//            var fbToken = session.accessTokenData.accessToken
//            
//            var url = "http://localhost:1337/auth/facebook/token?access_token=" + fbToken
//            
//            Alamofire.request(.POST, url).responseString() {
//                (_, _, data, _) in
//                println(data)
//            }
//        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        FBAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Facebook 
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        var wasHandled = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        
        return wasHandled
    }
    
    // MARK: - SOCKET.io
    
    func socketIODidConnect(socket: SocketIO!) {
        print("Socket: Connected!")
    }
    
    func socketIO(socket: SocketIO!, onError error: NSError!) {
        print("Socket: Error!")
    }
    
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.loganisitt.SwagSwap" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SwagSwap", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SwagSwap.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

