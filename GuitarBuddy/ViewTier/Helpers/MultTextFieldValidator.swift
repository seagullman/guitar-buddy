//
//  MultTextFieldValidator.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import UIKit


public protocol TextFieldValidatorDelegate: class {
    func allFieldsHaveText(validated: Bool)
}

/***
 *  Validates that any number of UITextFields contain text and informs the TextFieldValidatorDelegate
 *  upon editing change. In UIViewControllers requiring this
 *  functionality, instantiate MultipleTextFieldValidator inside viewWillAppear()
 *  and then call set(textFields: [UITextField]) passing the UITextFields to be validated
 *  upon editing.
 */
public class MultipleTextFieldValidator {
    
    public var delegate: TextFieldValidatorDelegate?
    
    private var textFields: [UITextField]?
    
    public func set(textFields: [UITextField]) {
        self.textFields = textFields
        setTargets()
    }
    
    private func setTargets() {
        guard let fields = self.textFields else { return }
        fields.forEach { (field) in
            field.addTarget(self, action: #selector(checkFieldsForEmpty), for: .editingChanged)
        }
    }
    
    @objc private func checkFieldsForEmpty() {
        let emptyFields = textFields?.filter({
            guard let isEmpty = $0.text?.isEmpty else { return false }
            return isEmpty
        })
        guard let count = emptyFields?.count else { return }
        if count > 0 {
            delegate?.allFieldsHaveText(validated: false)
        } else {
            delegate?.allFieldsHaveText(validated: true)
        }
    }
}
