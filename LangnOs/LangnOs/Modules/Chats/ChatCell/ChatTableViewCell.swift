//
//  ChatTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ChatTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20.0
        }
    }
    @IBOutlet private weak var usernameLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ChatCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func bindViewModel() {
        usernameLabel.text = viewModel?.name
    }
    
    // MARK: - Actions
    
}
