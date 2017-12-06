//
//  UIViewController+GuitarBuddy.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


internal extension UIViewController {
    
    internal func presentError(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let actionTitle = "Dismiss"
        let dismissAction = UIAlertAction(
            title: actionTitle,
            style: UIAlertActionStyle.default,
            handler: completion
        )
        showAlertDialog(with: message, title: nil, actions: [dismissAction])
    }
    
    internal func showAlertDialog(with text: String, title: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        actions.forEach { (action) in
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
