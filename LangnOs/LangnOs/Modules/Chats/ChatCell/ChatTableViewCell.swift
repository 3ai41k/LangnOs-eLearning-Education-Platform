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
    
    @IBOutlet private weak var chatImageView: UIImageView!
    @IBOutlet private weak var chatShortNameLabel: UILabel!
    @IBOutlet private weak var chatNameLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
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
        chatNameLabel.text = viewModel?.name
        chatShortNameLabel.text = viewModel?.shortName
    }
    
    // MARK: - Actions
    
}
