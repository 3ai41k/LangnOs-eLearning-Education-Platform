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
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var termInputView: InputView! {
        didSet {
            termInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setTerm(text)
            }
        }
    }
    @IBOutlet private weak var definitionInputView: InputView! {
        didSet {
            definitionInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setDefinition(text)
            }
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: (CreateWordTableViewCellInputProtocol & CreateWordTableViewCellOutputProtocol)? {
        didSet {
            termInputView.value = viewModel?.term
            definitionInputView.value = viewModel?.definition
        }
    }
    
}
