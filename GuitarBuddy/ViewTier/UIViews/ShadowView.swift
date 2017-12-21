//
//  ShadowView.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/14/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public class ShadowView: UIView {
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layer = self.layer
        let path = UIBezierPath(rect: layer.bounds).cgPath
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.9
        layer.shadowPath = path
    }
    
}
