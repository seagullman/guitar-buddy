//
//  AuthenticatedLandingViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/7/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public class AuthenticatedLandingViewController: UIViewController {

    @IBAction func signOut() {
        let command = SignOutCommand()
        let success = command.execute()
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            NSLog("ERROR") // TODO: handle
        }
    }
    
}
