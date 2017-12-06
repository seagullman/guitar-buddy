//
//  CreateAccountViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit
import SPRingboard


public class CreateAccountViewController: UIViewController {
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var guitarTypeTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func createAccount() {
        guard
            let firstName = self.firstNameTextField.text,
            let lastName = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let guitarType = self.guitarTypeTextField.text
        else {
            presentError(message: "All fields are required")
            return
        }
        
        let request = CreateAccountRequest(email: email, firstName: firstName, guitarType: guitarType, lastName: lastName, password: password)
        
        let command = CreateAccountCommand()
        FullScreenActivityPresenter.shared.showActivityIndicator(forViewController: self)
        command.execute(request: request).then { (result) in
            FullScreenActivityPresenter.shared.hideActivityIndicator(forViewController: self)
            switch result {
            case .success(let success):
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.presentError(message: "Generic error message.") // TODO: create constants file
                }
            case .failure(let error):
                let errorDescription = error.localizedDescription
                self.presentError(message: errorDescription)
            }
        }
    }
    
}
