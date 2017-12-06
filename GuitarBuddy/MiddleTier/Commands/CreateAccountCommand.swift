//
//  CreateAccountCommand.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


public class CreateAccountCommand {
    
    private let createUserAccount: ((CreateAccountRequest) -> FutureResult<CreateUserResponse>)
    private let registerUser: ((CreateUserResponse) -> FutureResult<Bool>)
    
    internal init(
        accountCreator: @escaping (CreateAccountRequest) -> FutureResult<CreateUserResponse>,
        userRegistrar: @escaping (CreateUserResponse) -> FutureResult<Bool>
    ) {
        self.createUserAccount = accountCreator
        self.registerUser = userRegistrar
    }
    
    public convenience init() {
        let client = NetworkGuitarBuddyClient.shared
        let accountCreator = client.createUser
        let userRegistrar = client.register
        self.init(accountCreator: accountCreator, userRegistrar: userRegistrar)
    }
    
    public func execute(request: CreateAccountRequest) -> FutureResult<Bool> {
        let createAccount = self.createUserAccount(request)
        .pipe(into: self.registerUser)
        return createAccount
    }
    
}
