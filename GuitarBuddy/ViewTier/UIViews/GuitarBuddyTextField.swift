//
//  GuitarBuddyTextField.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/21/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public class GuitarBuddyTextField: UITextField {

    public override func awakeFromNib() {
        self.layer.cornerRadius = 7
        self.layer.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).cgColor
        self.textColor = UIColor(red:0.75, green:0.75, blue:0.77, alpha:1.0)
    }

}
