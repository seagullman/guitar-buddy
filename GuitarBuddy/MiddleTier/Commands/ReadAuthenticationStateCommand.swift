//
//  ReadAuthenticationStateCommand.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/7/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


public class ReadAuthenticationStateCommand {
    
    private let authStateReader: (() -> FutureResult<AuthState>)
    
    internal init(authStateReader: @escaping () -> FutureResult<AuthState>) {
        self.authStateReader = authStateReader
    }
    
    public convenience init() {
        let client = NetworkGuitarBuddyClient.shared
        let authStateReader = client.getAuthenticationState
        self.init(authStateReader: authStateReader)
    }
    
    public func executute() -> FutureResult<AuthState> {
        return self.authStateReader()
    }
    
}
