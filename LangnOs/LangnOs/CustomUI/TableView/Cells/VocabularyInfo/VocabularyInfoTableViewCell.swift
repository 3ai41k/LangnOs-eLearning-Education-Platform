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
                self?.viewModel?.setName(text)
            }
        }
    }
    @IBOutlet weak var categoryInputView: InputView! {
        didSet {
            categoryInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setCategory(text)
            }
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: (VocabularyInfoViewCellInputProtocol & VocabularyInfoViewCellOutputProtocol & VocabularyInfoViewCellBindingProtocol)? {
        didSet {
            nameInputView.value = viewModel?.name
            categoryInputView.value = viewModel?.category
            
            viewModel?.resignFirstResponders = { [weak self] in
                [self?.nameInputView, self?.categoryInputView].forEach({ $0?.resignFirstResponder() })
            }
        }
    }
    
}
