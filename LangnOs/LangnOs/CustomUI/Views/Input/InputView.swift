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
    @IBOutlet private weak var textField: UITextField!
    
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
    
    // MARK: - Actions
    
    @IBAction
    private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        textDidEnter?(text)
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
        
        self.textField.placeholder = model.placeholder
        self.textDidEnter = model.textDidEnter
    }
    
}
