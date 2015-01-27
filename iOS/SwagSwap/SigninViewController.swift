//
//  ViewController.swift
//  SwagSwap
//
//  Created by Logan Isitt on 12/14/14.
//  Copyright (c) 2014 loganisitt. All rights reserved.
//

import UIKit
import Alamofire

class SigninViewController: UIViewController, FBLoginViewDelegate, SocketIODelegate {
    
    var socketio: SocketIO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketio = SocketIO(delegate: self)
        socketio.connectToHost("localhost", onPort: 8080)
    }
    
    @IBAction func facebookLoginAction(sender: UIButton) {
        if FBSession.activeSession().state == FBSessionState.Open || FBSession.activeSession().state == FBSessionState.OpenTokenExtended {
            FBSession.activeSession().closeAndClearTokenInformation();
        }
        else {
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: { (session, state, error) -> Void in
                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.sessionStateChanged(session, state: state, error: error)
            })
        }
    }
}