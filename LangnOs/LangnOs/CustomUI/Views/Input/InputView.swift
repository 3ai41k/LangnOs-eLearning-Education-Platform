//
//  InputView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class InputView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    // MARK: - Public properties
    
    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
        }
    }
    
    var value: String? {
        didSet {
            textField.text = value
        }
    }
    
    var isEditable: Bool = true {
        didSet {
            textField.isUserInteractionEnabled = isEditable
        }
    }
    
    var textFieldInputAccessoryView: UIView? {
        didSet {
            textField.inputAccessoryView = textFieldInputAccessoryView
        }
    }
    
    var textDidEnter: ((String) -> Void)?
    
    // MARK: - Overrride
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction
    private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        textDidEnter?(text)
    }

}

// MARK: - UITextFieldDelegate

extension InputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

// MARK: - DrivableViewProtocol

extension InputView: DrivableViewProtocol {
    
    func drive(model: DrivableModelProtocol?) {
        drive(model: model as? InputViewDrivableModel)
    }
    
    private func drive(model: InputViewDrivableModel?) {
        guard let model = model else { return }
        
        if let text = model.text {
            self.titleLabel.text = text
        } else {
            self.titleLabel.isHidden = true
        }
        
        self.textField.drive(model: model.textFieldDrivableModel)
        self.textDidEnter = model.textDidEnter
    }
    
}
