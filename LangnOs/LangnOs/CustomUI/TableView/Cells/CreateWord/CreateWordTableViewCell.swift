//
//  CreateWordTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class CreateWordTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var termTextField: UITextField!
    @IBOutlet weak private var definitionTextField: UITextField!
    
    // MARK: - Public properties
    
    var viewModel: (CreateWordTableViewCellInputProtocol & CreateWordTableViewCellOutputProtocol)? {
        didSet {
            termTextField.text = viewModel?.term
            definitionTextField.text = viewModel?.definition
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [termTextField, definitionTextField].forEach({ $0?.delegate = self })
    }
    
}

// MARK: - UITextFieldDelegate

extension CreateWordTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case termTextField:
            viewModel?.setTerm(text)
        case definitionTextField:
            viewModel?.setDefinition(text)
        default:
            return
        }
    }
    
}
