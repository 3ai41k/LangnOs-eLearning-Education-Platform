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
            containerView.setShadow(color: .black, opacity: 0.25)
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
            [termInputView, definitionInputView].forEach({
                let sreenWidth = UIScreen.main.bounds.width
                let rect = CGRect(x: .zero, y: .zero, width: sreenWidth, height: 44.0)
                let toolbar = UIToolbar(frame: rect)
                toolbar.drive(model: viewModel?.toolbarDrivableModel)
                $0?.textFieldInputAccessoryView = toolbar
            })
        }
    }
    
}
