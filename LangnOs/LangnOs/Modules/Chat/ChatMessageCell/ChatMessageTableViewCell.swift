//
//  OutcomingMessageTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ChatMessageCellViewModelInputProtocol {
    var content: String { get }
    var textAlignment: NSTextAlignment { get }
}

typealias ChatMessageCellViewModelProtocol =
    ChatMessageCellViewModelInputProtocol &
    CellViewModelProtocol

final class ChatMessageTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ChatMessageCellViewModelProtocol? {
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
        messageLabel.text = viewModel?.content
        messageLabel.textAlignment = viewModel?.textAlignment ?? .natural
    }
    
    // MARK: - Actions
    
}
