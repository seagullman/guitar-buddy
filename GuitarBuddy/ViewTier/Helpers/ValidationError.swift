//
//  ValidationError.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/11/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


public final class GBValidationError {
    public static let passwordMismatch = "Oops, passwords do not match."
    public static let invalidPasswordLength = "Passwords must be at least \(Environment.minimumPasswordLength) characters."
}
