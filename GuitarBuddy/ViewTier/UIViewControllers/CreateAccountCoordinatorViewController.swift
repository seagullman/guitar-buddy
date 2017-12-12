//
//  CreateAccountCoordinatorViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit
import SPRingboard


public protocol CreateAccountCoordinatorDelegate: class {
    func accountCreated()
}

public class CreateAccountCoordinatorViewController: UIViewController,
                                                     CreateAccountHeaderDelegate,
                                                     CreateAccountTableDelegate,
                                                     CreateAccountFooterDelegate {
    
    private var tableViewController: CreateAccountTableViewController?
    private var footerViewController: CreateAccountFooterViewController?
    
    internal var delegate: CreateAccountCoordinatorDelegate?

    // MARK: UIViewController
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showCreateAccoutHeaderVC":
            guard let destination = segue.destination as? CreateAccountHeaderViewController else { return }
            
            destination.delegate = self
        case "showCreateAccountTableVC":
            guard let destination = segue.destination as? CreateAccountTableViewController else { return }
            
            self.tableViewController = destination
            destination.delegate = self
        case "showCreateAccountFooterVC":
            guard let destination = segue.destination as? CreateAccountFooterViewController else { return }
            
            self.footerViewController = destination
            destination.delegate = self
        default:
            NSLog("Unrecognized identifier is sent: \(identifier)")
            abort()
        }
    }
    
    // MARK: - CreateAccountHeaderDelegate
    
    public func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CreateAccountTableDelegate
    
    public func allFieldsHaveText(validated: Bool) {
        self.footerViewController?.toggleSignUpButton(enabled: validated)
    }
    
    // MARK: - CreateAccountFooterDelegate
    
    public func signUpUser() {
        guard
            let validationResult: ValidationResult<Bool> = self.tableViewController?.validatePassword()
        else { return }
        
        switch validationResult {
        case .success:
            self.createAccount()
        case .failure(let errorText):
            self.presentError(message: errorText)
        }
    }
    
    // MARK: Private Functions
    
    private func createAccount() {
        guard let request = self.tableViewController?.getRequest() else { return }
        
        let command = CreateAccountCommand()
        FullScreenActivityPresenter.shared.showActivityIndicator(forViewController: self)
        command.execute(request: request).then { (result) in
            FullScreenActivityPresenter.shared.hideActivityIndicator(forViewController: self)
            switch result {
            case .success(let success):
                if success {
                    self.delegate?.accountCreated()
                } else {
                    self.presentError(message: "We were unable to create your account. Please try again later.") // TODO: create constants file
                }
            case .failure(let error):
                let errorDescription = error.localizedDescription
                self.presentError(message: errorDescription)
            }
        }
    }
    
}
