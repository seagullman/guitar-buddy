//
//  CreateSongCommand.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/22/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


public class CreateSongCommand {
    
    private let createSong: ((CreateSongRequest) -> FutureResult<Bool>)
    
    internal init(songCreator: @escaping (CreateSongRequest) -> FutureResult<Bool>) {
        self.createSong = songCreator
    }
    
    public convenience init() {
        let client = NetworkGuitarBuddyClient.shared
        let songCreator = client.createSong
        self.init(songCreator: songCreator)
    }
    
    public func execute(request: CreateSongRequest) -> FutureResult<Bool> {
        let deferred = DeferredResult<Bool>()
        _ = self.createSong(request)
            .then { (result) in
                switch result {
                case .success(let success):
                    deferred.success(value: success)
                case .failure(let error):
                    NSLog("ERROR: Failed to create new song. Error: \(error)")
                    deferred.failure(error: error)
                }
        }
        return deferred
    }
    
}
