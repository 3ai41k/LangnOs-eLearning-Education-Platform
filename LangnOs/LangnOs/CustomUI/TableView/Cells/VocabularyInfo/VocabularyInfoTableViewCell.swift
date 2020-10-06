//
//  VocabularyInfoTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyInfoTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var nameInputView: InputView! {
        didSet {
            nameInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setTitle(text)
            }
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: (VocabularyInfoViewCellInputProtocol & VocabularyInfoViewCellOutputProtocol & VocabularyInfoViewCellBindingProtocol)? {
        didSet {
            nameInputView.value = viewModel?.title
            
            viewModel?.resignFirstResponders = { [weak self] in
                self?.nameInputView.resignFirstResponder()
            }
        }
    }
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
}
