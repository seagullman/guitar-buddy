//
//  CreateAccountRequest.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


public struct CreateAccountRequest {
    public let email: String
    public let firstName: String
    public let guitarType: String // TODO: make enum
    public let lastName: String
    public let password: String
}
