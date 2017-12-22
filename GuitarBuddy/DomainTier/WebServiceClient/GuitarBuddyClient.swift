
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
    func createSong(fromRequest request: CreateSongRequest) -> FutureResult<Bool>
    func createUser(fromRequest request: CreateAccountRequest) -> FutureResult<CreateUserResponse>
    func getAuthenticationState() -> FutureResult<AuthState>
    func getUsersSongs() -> FutureResult<[Song]>
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
    
    internal func createSong(fromRequest request: CreateSongRequest) -> FutureResult<Bool> {
        guard let userId = Auth.auth().currentUser?.uid else {
            NSLog("FATAL: getUsersSongs -- Unable to retrieve current user uid from auth object.")
            abort()
        }
        
        let deferred = DeferredResult<Bool>()
        let ref = Database.database().reference(fromURL: Environment.firebaseUrl)
        let userRef = ref.child("users").child(userId)
        let songsRef = ref.child("songs")
        songsRef.childByAutoId().setValue(request.toDictionary()) { (error, reference) in
            if let error = error {
                deferred.failure(error: error)
            } else {
                let key = reference.key
                userRef.child("songs").child(key).setValue(true)
                deferred.success(value: true)
            }
        }
        return deferred
    }
    
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
    
    internal func getUsersSongs() -> FutureResult<[Song]> {
        let deferred = DeferredResult<[Song]>()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            NSLog("FATAL: getUsersSongs -- Unable to retrieve current user uid from auth object.")
            abort()
        }
        
        let ref = Database.database().reference(fromURL: Environment.firebaseUrl)
        let userRef = ref.child("users").child(userId)
        let songsRef = ref.child("songs")
        let userSongsRef = userRef.child("songs").queryOrderedByValue().queryEqual(toValue: true)
        var songs = [Song]()
        
        userSongsRef.observeSingleEvent(of: .value) { (userSongSnapshot) in
            guard
                let snaps = userSongSnapshot.children.allObjects as? [DataSnapshot],
                snaps.count > 0
            else {
                return deferred.success(value: songs)
            }
            
            snaps.forEach({ (songSnapshot) in
                songsRef.child(songSnapshot.key).observeSingleEvent(of: .value, with: { (indvSongSnap) in
                    let song = Song(snapshot: indvSongSnap)
                    songs.append(song)
                    
                    if songs.count == snaps.count {
                        deferred.success(value: songs)
                    }
                })
            })
        }
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
