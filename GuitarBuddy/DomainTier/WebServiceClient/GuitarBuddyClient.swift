//
//  GuitarBuddyClient.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard
import Firebase
import FirebaseDatabase

internal protocol GuitarBuddyClient: class {
    func createUser(fromRequest request: CreateAccountRequest) -> FutureResult<CreateUserResponse>
}

fileprivate let sharedNetworkClient = NetworkGuitarBuddyClient()


public struct CreateUserResponse {
    public let userId: String
    public let request: CreateAccountRequest
}

internal class NetworkGuitarBuddyClient: GuitarBuddyClient {
    
    public static let shared: NetworkGuitarBuddyClient = sharedNetworkClient
    
    // MARK: - GuitarBuddyClient
    
    internal func createUser(fromRequest request: CreateAccountRequest) -> FutureResult<CreateUserResponse> {
        let deferred = DeferredResult<CreateUserResponse>()
        let email = request.email
        let password = request.password
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                deferred.failure(error: error)
            } else {
                if let userId = user?.uid  {
                    let response = CreateUserResponse(userId: userId, request: request)
                    deferred.success(value: response)
                } else {
                    // User's uid is nil
                    let error = GuitarBuddyError.invalidServerResponse(message: "ERROR: user's uid is nil.")
                    deferred.failure(error: error)
                }
            }
        }
        return deferred
    }
    
    internal func register(fromResponse response: CreateUserResponse) -> FutureResult<Bool> {
        let deferred = DeferredResult<Bool>()
        let id = response.userId
        let reference = Database.database().reference(fromURL: Environment.firebaseUrl)
        let userReference = reference.child("users").child(id)
        
        let body: [String: Any] = [
            "email": response.request.email,
            "guitarType": response.request.guitarType
        ]
        
        userReference.updateChildValues(body)
        deferred.success(value: true)
        return deferred
    }
    
}
