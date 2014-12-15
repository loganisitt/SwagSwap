//
//  ViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 12/14/14.
//  Copyright (c) 2014 loganisitt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate, SocketIODelegate {
    
    var socketio: SocketIO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketio = SocketIO(delegate: self)
        socketio.connectToHost("localhost", onPort: 1337)
        socketio.sendMessage("Hello!", withAcknowledge: nil)
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
}

