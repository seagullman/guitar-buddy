//
//  CreateAccountHeaderViewController.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public protocol CreateAccountHeaderDelegate: class {
    func cancelButtonTapped()
}

public class CreateAccountHeaderViewController: UIViewController {

    public var delegate: CreateAccountHeaderDelegate?
    
    @IBAction func cancelTapped() {
        self.delegate?.cancelButtonTapped()
    }
    
}
