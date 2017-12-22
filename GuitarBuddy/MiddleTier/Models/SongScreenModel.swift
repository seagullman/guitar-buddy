//
//  GBSongScreenModel.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/14/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


public struct SongScreenModel {
    
    private let song: Song
    
    public init(song: Song) {
        self.song = song
    }
    
    public var artistImage: String {
        // TODO:
        //return self.song.artistImage
        return "artistPlaceholder"
    }
    
    public var songName: String {
        return self.song.name
    }
    
    public var artistName: String {
        return self.song.artist
    }
    
    public var songGenre: String {
        return self.song.genre
    }
    
    public var confidenceLevelText: String {
        return "\(self.song.confidenceLevel) confidence"
    }
    
    public var numberOfVideosText: String {
        return "\(self.song.videoCount) videos"
    }
    
}
