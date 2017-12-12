//
//  LaunchFlowController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


internal protocol LaunchFlowControllerDelegate: class {
    func signOut()
}

public class LaunchFlowController {
    
    internal var delegate: LaunchFlowControllerDelegate?
    
    // MARK: - Initialization
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.determineDestination), name: .startLaunchFlow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signOut), name: .signOut , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selector Functions
    
    @objc internal func determineDestination() {
        let readAuthStateCommand = ReadAuthenticationStateCommand()
        readAuthStateCommand.executute().then { (result) in
            switch result {
            case .success(let state):
                if state == AuthState.authenticated {
                    // User is authenticated, post authenticated flow notification
                    let notification = Notification(name: .showAuthenticatedFlow)
                    NotificationCenter.default.post(notification)
                } else {
                    // User is not authenticated, post setup flow notification
                    let notification = Notification(name: .showSetupFlow)
                    NotificationCenter.default.post(notification)
                }
            case .failure(let error):
                NSLog("ERROR: Failed to read authentication state. Error: \(error)")
                // Error retrieving authentication state. Post setup flow notification
                let notification = Notification(name: .showSetupFlow)
                NotificationCenter.default.post(notification)
            }
        }
    }
    
    // MARK: - Selector Functions
    
    @objc private func signOut() {
        delegate?.signOut()
    }
    
}
