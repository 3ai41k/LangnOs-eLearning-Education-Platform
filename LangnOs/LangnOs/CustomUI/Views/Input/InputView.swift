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
            guard let text = title else { return }
            titleLabel.text = text + ":"
        }
    }
    
    var value: String? {
        didSet {
            textField.text = value
        }
    }
    
    var textDidEnter: ((String) -> Void)?
    
    // MARK: - Override
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

}

// MARK: - UITextFieldDelegate

extension InputView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textDidEnter?(text)
    }
    
}
