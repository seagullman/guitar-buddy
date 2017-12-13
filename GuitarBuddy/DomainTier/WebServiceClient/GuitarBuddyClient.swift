
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
import FirebaseAuth

public enum AuthState {
    case authenticated
    case notAuthenticated
}

internal protocol GuitarBuddyClient: class {
    func createUser(fromRequest request: CreateAccountRequest) -> FutureResult<CreateUserResponse>
    func getAuthenticationState() -> FutureResult<AuthState>
    func register(fromResponse response: CreateUserResponse) -> FutureResult<Bool>
    func signIn(withEmail email: String, password: String) -> FutureResult<GuitarBuddyUser>
    func signOut() -> Bool
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
        
        // Creates user and, upon success, logs the user in with the givin username and password
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                deferred.failure(error: error)
            } else {
                if let userId = user?.uid  {
                    let response = CreateUserResponse(userId: userId, request: request)
                    deferred.success(value: response)
                } else {
                    // User's uid is nil
                    let error = GuitarBuddyError.invalidResponse
                    deferred.failure(error: error)
                }
            }
        }
        return deferred
    }
    
    internal func getAuthenticationState() -> FutureResult<AuthState> {
        let deferred = DeferredResult<AuthState>()
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                deferred.success(value: AuthState.authenticated)
            } else {
                deferred.success(value: AuthState.notAuthenticated)
            }
        }
        Auth.auth().removeStateDidChangeListener(handle)
        return deferred
    }
    
    internal func register(fromResponse response: CreateUserResponse) -> FutureResult<Bool> {
        let deferred = DeferredResult<Bool>()
        let id = response.userId
        let reference = Database.database().reference(fromURL: Environment.firebaseUrl)
        let userReference = reference.child("users").child(id)
        
        let body: [String: Any] = [
            "firstName": response.request.firstName,
            "lastName": response.request.lastName,
            "email": response.request.email,
            "guitarType": response.request.guitarType
        ]
        
        userReference.updateChildValues(body)
        deferred.success(value: true)
        return deferred
    }
    
    internal func signIn(withEmail email: String, password: String) -> FutureResult<GuitarBuddyUser> {
        let deferred = DeferredResult<GuitarBuddyUser>()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let user = user,
               error == nil {
                let userId = user.uid
                let user = GuitarBuddyUser(id: userId)
                deferred.success(value: user)
            } else {
                if let error = error {
                    deferred.failure(error: error)
                }
            }
        }
        return deferred
    }
    
    internal func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch (let error) {
            NSLog("ERROR: unable to sign user out: \(error)")
            return false
        }
    }
    
}
