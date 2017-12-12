//
//  LoginViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/7/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public class LoginViewController: UIViewController,
                                  CreateAccountCoordinatorDelegate {
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showSignUpScreen":
            guard let destination = segue.destination as? CreateAccountCoordinatorViewController else { return }
            
            destination.delegate = self
        default:
            NSLog("Unrecognized identifier is sent: \(identifier)")
            abort()
        }
    }
    
    // MARK: - CreateAccountCoordinatorDelegate
    
    public func accountCreated() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
