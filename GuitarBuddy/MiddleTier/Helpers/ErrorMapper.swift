//
//  ErrorMapper.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/12/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import FirebaseAuth


public class ErrorMapper {
    
    private static let genericErrorMessage = "Oops something went wrong. Please try again later."
    
    public static func convertToGBError(forError error: Error) -> GuitarBuddyError {
        let errorText: String
        if let errCode = AuthErrorCode(rawValue: error._code) {
            
            switch errCode {
            case .invalidEmail, .wrongPassword:
                errorText = "Sorry, your email or password is incorrect. Please try again."
            case .emailAlreadyInUse:
                errorText = "That email is already in use. Please try another email."
            default:
                errorText = genericErrorMessage
            }
        } else {
            errorText = genericErrorMessage
        }
        return GuitarBuddyError.invalidServerResponse(message: errorText)
    }
    
    public static func errorMessage(forError error: Error) -> String {
        let errorText: String
        switch error {
        case GuitarBuddyError.invalidServerResponse(let errorMessage):
            errorText = errorMessage
        default:
            errorText = "Oops, something went wrong, please try again shortly."
        }
        return errorText
    }
    
}
