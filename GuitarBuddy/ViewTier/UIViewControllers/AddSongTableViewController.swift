//
//  AddSongViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/21/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit

public protocol AddSongDelegate: class {
    func songAdded()
}

public class AddSongTableViewController: UITableViewController {

    @IBOutlet weak var addSongButton: GuitarBuddyButton!
    @IBOutlet weak var artistTextField: GuitarBuddyTextField!
    @IBOutlet weak var confidenceTextField: GuitarBuddyTextField!
    @IBOutlet weak var genreTextField: GuitarBuddyTextField!
    @IBOutlet weak var songNameTextField: GuitarBuddyTextField!
    
    internal var delegate: AddSongDelegate?
    
    // MARK: IBActions
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSong() {
        guard
            let artist = self.artistTextField.text,
            let confidence = self.confidenceTextField.text,
            let genre = self.genreTextField.text,
            let songName = self.songNameTextField.text
        else { return }
        
        let request = CreateSongRequest(
            artist: artist,
            confidence: Double(confidence) ?? 0,
            genre: genre, songName:
            songName,
            videoCount: 0
        )
        
        let command = CreateSongCommand()
        command.execute(request: request)
            .then { (result) in
                switch result {
                case .success(let success):
                    if success {
                        self.delegate?.songAdded()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // TODO: show error
                    }
                case .failure(let error):
                    NSLog("Failed to create new song. Error: \(error)")
                    // TODO: show error
                }
        }
    }
    
}
