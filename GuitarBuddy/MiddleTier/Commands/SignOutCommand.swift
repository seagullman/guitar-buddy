//
//  SignOutCommand.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/7/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


public class SignOutCommand {
    
    private let signOut: (() -> Bool)
    
    internal init(signOut: @escaping () -> Bool) {
        self.signOut = signOut
    }
    
    public convenience init() {
        let client = NetworkGuitarBuddyClient.shared
        let signOut = client.signOut
        self.init(signOut: signOut)
    }
    
    public func execute() -> Bool  {
        return self.signOut()
    }
    
}
