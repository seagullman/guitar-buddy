//
//  GBSong.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/14/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import Firebase


public struct Song {
    let id: String
//    let artistImage: String
    let name: String
    let artist: String
    let confidenceLevel: Double
    let genre: String
    let videoCount: Int
    
    public init(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else {
            NSLog("FATAL: Unexpected snapshot: Unable to convert to dictionary.")
            abort()
        }
        
        self.id = snapshot.key
        self.name = dict["songName"] as? String ?? ""
        self.artist = dict["artist"] as? String ?? ""
        self.confidenceLevel = dict["confidenceLevel"] as? Double ?? 0
        self.genre = dict["genre"] as? String ?? ""
        self.videoCount = dict["videoCount"] as? Int ?? 0
    }
    
}
