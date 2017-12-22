//
//  CreateSongRequest.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/21/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


public struct CreateSongRequest {
    public let artist: String
    public let confidence: Double
    public let genre: String
    public let songName: String
    public let videoCount: Int
    
    public func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "artist": self.artist,
            "confidenceLevel": self.confidence,
            "genre": self.genre,
            "songName": self.songName,
            "videoCount": self.videoCount
        ]
        return dict
    }
}
