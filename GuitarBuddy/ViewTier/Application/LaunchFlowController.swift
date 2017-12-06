//
//  LaunchFlowController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


public class LaunchFlowController {
    
    // MARK: - Initialization
    
    public init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.determineDestination),
            name: .startLaunchFlow ,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selector Functions
    
    @objc internal func determineDestination() {
        let authenticated = false
        
        if authenticated {
            // User is authenticated, post authenticated flow notification
            let notification = Notification(name: .showAuthenticatedFlow)
            NotificationCenter.default.post(notification)
        } else {
            // User is not authenticated, post setup flow notification
            let notification = Notification(name: .showSetupFlow)
            NotificationCenter.default.post(notification)
        }

    }
    
}
