//
//  GBPasswordValidator.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/11/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


public enum ValidationResult<T> {
    case success(T)
    case failure(String)
}

public class GBPasswordValidator {
    
    private let passwordText: String
    private let confirmPasswordText: String
    
    public init(passwordText: String, confirmPasswordText: String) {
        self.passwordText = passwordText
        self.confirmPasswordText = confirmPasswordText
    }
    
    // MARK: Public Functions
    
    public func validate() -> ValidationResult<Bool> {
        var result: ValidationResult<Bool>
        if (self.passwordText == self.confirmPasswordText) {
            if passwordText.count < Environment.minimumPasswordLength {
                // Invalid password length
                result = ValidationResult.failure(GBValidationError.invalidPasswordLength)
            } else {
                // Password matches and is valid length
                result = ValidationResult.success(true)
            }
        } else {
            // Passwords do not match
            result = ValidationResult.failure(GBValidationError.passwordMismatch)
        }
        return result
    }
    
}
