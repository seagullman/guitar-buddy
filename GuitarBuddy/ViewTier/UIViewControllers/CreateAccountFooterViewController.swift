//
//  CreateAccountFooterViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public protocol CreateAccountFooterDelegate: class {
    func signUpUser()
}

public class CreateAccountFooterViewController: UIViewController {
    
    public var delegate: CreateAccountFooterDelegate?
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    // Internal Functions
    
    internal func toggleSignUpButton(enabled: Bool) {
        self.signUpButton.isEnabled = enabled
    }

    // MARK: - IBActions
    
    @IBAction func signUpUser() {
        self.delegate?.signUpUser()
    }
    
}
