//
//  CreateAccountViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit
import SPRingboard

public protocol CreateAccountTableDelegate: class {
    func allFieldsHaveText(validated: Bool)
}

public class CreateAccountTableViewController: UITableViewController,
                                               TextFieldValidatorDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var guitarTypeTextField: UITextField!
    
    private var validator: MultipleTextFieldValidator?
    
    public var delegate: CreateAccountTableDelegate?
    
    // MARK: - UIViewController
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.validator = MultipleTextFieldValidator()
        
        let fieldsToBeValidated: [UITextField] = [
            self.firstNameTextField,
            self.lastNameTextField,
            self.emailTextField,
            self.passwordTextField,
            self.confirmPasswordTextField,
            self.guitarTypeTextField
        ]
        self.validator?.set(textFields:fieldsToBeValidated)
        self.validator?.delegate = self
    }
    
    // MARK: Internal Functions
    
    internal func getRequest() -> CreateAccountRequest? {
        var req: CreateAccountRequest?
        if
            let firstName = self.firstNameTextField.text,
            let lastName = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text?.trimmingCharacters(in: .whitespaces),
            let guitarType = self.guitarTypeTextField.text {
            
            let request = CreateAccountRequest(
                email: email,
                firstName: firstName,
                guitarType: guitarType,
                lastName: lastName,
                password: password
            )
            req = request
            
        } 
        return req
    }
    
    internal func validatePassword() -> ValidationResult<Bool> {
        // All fields will have > 0 characters in them at this point
        guard
            let passwordText = self.passwordTextField.text?.trimmingCharacters(in: .whitespaces),
            let confirmPasswordText = self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces)
        else {
            NSLog("FATAL: Attempting to validate empty password fields.")
            abort()
        }
        
        let validator = GBPasswordValidator(passwordText: passwordText, confirmPasswordText: confirmPasswordText)
        let result = validator.validate()
        return result
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextFieldValidatorDelegate
    
    public func allFieldsHaveText(validated: Bool) {
        self.delegate?.allFieldsHaveText(validated: validated)
    }
    
}
