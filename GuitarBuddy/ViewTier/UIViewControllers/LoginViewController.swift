//
//  LoginViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/7/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public class LoginViewController: UIViewController,
                                  CreateAccountCoordinatorDelegate,
                                  TextFieldValidatorDelegate {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var validator: MultipleTextFieldValidator?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.validator = MultipleTextFieldValidator()
        self.validator?.set(textFields: [emailTextField, passwordTextField])
        self.validator?.delegate = self
    }
    
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
    
    // MARK: - IBActions
    
    @IBAction func signUserIn() {
        guard
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text
        else { return }
        
        let command = SignInCommand()
        _ = command.execute(email: email, password: password)
        .then { (result) in
            switch result {
            case .success:
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                let errorText = ErrorMapper.errorMessage(forError: error)
                self.presentError(message: errorText)
            }
        }
    }
    
    // MARK: - CreateAccountCoordinatorDelegate
    
    public func accountCreated() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextFieldValidatorDelegate
    
    public func allFieldsHaveText(validated: Bool) {
        self.loginButton.isEnabled = true
    }

}
