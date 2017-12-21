//
//  AuthenticatedLandingViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/7/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit
import SPRingboard


public class MySongsTableViewController: SPRTableViewController {
    
    // MARK: - UIViewController
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .white
        self.navigationItem.searchController = searchController
    }

    // MARK: - SPRTableViewController
    
    public override func loadObjectDataSource() -> FutureResult<ObjectDataSource<Any>> {
        let deferred = DeferredResult<ObjectDataSource<Any>>()
        let command = ReadSongsCommand()
        command.execute().then { (result) in
            switch result {
            case .success(let dataSource):
                deferred.success(value: dataSource.asAny())
            case .failure(let error):
                deferred.failure(error: error)
            }
        }
        return deferred
    }
    
    public override func renderCell(in tableView: UITableView, withModel model: Any, at indexPath: IndexPath) throws -> UITableViewCell {
        let safeCell = self.tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        guard
            let cell = safeCell as? MySongsTableViewCell,
            let screenModel = model as? SongScreenModel
        else { return safeCell }
        
        let image = UIImage(named: screenModel.artistImage)
        cell.artistImageView.image = image
        cell.songNameLabel.text = screenModel.songName
        cell.artistNameLabel.text = screenModel.artistName
        cell.videoCountLabel.text = screenModel.numberOfVideosText
        cell.confidenceLevelLabel.text = screenModel.confidenceLevelText
        cell.songGenreLabel.text = screenModel.songGenre
        
        return cell
    }
    
    public override func loadingActivityPresenter() -> SPRViewControllerActivityPresenter? {
        return FullScreenActivityPresenter.shared
    }
    
    public override func enableControls() {
        self.tableView.isUserInteractionEnabled = true
    }
    
    public override func disableControls() {
        self.tableView.isUserInteractionEnabled = false
    }
    
    // MARK: - IBActions
    
    @IBAction func signOut(_ sender: Any) {
        let command = SignOutCommand()
        let success = command.execute()
        if success {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
