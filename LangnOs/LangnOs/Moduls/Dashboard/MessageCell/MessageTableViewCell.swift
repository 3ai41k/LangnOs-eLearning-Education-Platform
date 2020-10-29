//
//  MessageTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MessageTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 5.0
            button.layer.borderColor = UIColor.systemGray2.cgColor
            button.layer.borderWidth = 0.25
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: MessageCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        label.text = viewModel?.message
        button.isHidden = viewModel?.isButtonHidden ?? true
        button.setTitle(viewModel?.buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didButtonTouch(_ sender: Any) {
        viewModel?.buttonAction()
    }

}
