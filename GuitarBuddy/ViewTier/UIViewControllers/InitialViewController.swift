//
//  InitialViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public class InitialViewController: UIViewController {
    
    // MARK: - UIViewController
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.segueToScreen), name: .showSetupFlow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.segueToScreen), name: .showAuthenticatedFlow, object: nil)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notification = Notification(name: .startLaunchFlow)
        NotificationCenter.default.post(notification)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Functions
    
    @objc private func segueToScreen(notification: Notification) {
        guard self.presentedViewController == nil else {
            NSLog("Ignoring notification because the InitialViewController has already presented a VC: \(notification.name)")
            return
        }
        
        switch notification.name {
        case Notification.Name.showSetupFlow:
            performSegue(withIdentifier: "showSetupFlow", sender: nil)
        case Notification.Name.showAuthenticatedFlow:
            performSegue(withIdentifier: "showAuthenticatedFlow", sender: nil)
        default:
            performSegue(withIdentifier: "showSetupFlow", sender: nil)
        }
    }

}
