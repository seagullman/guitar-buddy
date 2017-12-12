//
//  SignInCommand.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/11/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


public class SignInCommand {
    
    private let signUserIn: ((String, String) -> FutureResult<GuitarBuddyUser>)
    
    internal init(signUserIn: @escaping (String, String) -> FutureResult<GuitarBuddyUser>) {
        self.signUserIn = signUserIn
    }
    
    public convenience init() {
        let client = NetworkGuitarBuddyClient.shared
        let signUserIn = client.signIn
        self.init(signUserIn: signUserIn)
    }
    
    public func execute(email: String, password: String) -> FutureResult<Bool> {
        let deferred = DeferredResult<Bool>()
        self.signUserIn(email, password)
        .then { (result) in
            switch result {
            case .success:
                deferred.success(value: true)
            case .failure(let error):
                NSLog("ERROR: failed to sign user in. Error: \(error)")
                deferred.failure(error: error)
            }
        }
        return deferred
    }
    
}
