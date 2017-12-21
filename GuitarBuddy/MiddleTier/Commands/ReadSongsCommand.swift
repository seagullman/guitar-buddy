//
//  ReadSongsCommand.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/14/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


public class ReadSongsCommand {
    
    private let songReader: (() -> FutureResult<[Song]>)
    
    internal init(songReader: @escaping () -> FutureResult<[Song]>) {
        self.songReader = songReader
    }
    
    public convenience init() {
        let client = NetworkGuitarBuddyClient.shared
        let songReader = client.getUsersSongs
        self.init(songReader: songReader)
    }
    
    public func execute() -> FutureResult<ObjectDataSource<SongScreenModel>> {
        let readSong = self.songReader()
        .pipe(into: convertToScreenModels(songs:))
        .pipe(into: createArrayObjectDataSource(withScreenModels:))
        return readSong
    }
    
    // MARK: - Private Functions
    
    private func convertToScreenModels(songs: [Song]) -> FutureResult<[SongScreenModel]> {
        let deferred = DeferredResult<[SongScreenModel]>()
        let screenModels = songs.map { SongScreenModel(song: $0) }
        deferred.success(value: screenModels)
        return deferred
    }
    
}
