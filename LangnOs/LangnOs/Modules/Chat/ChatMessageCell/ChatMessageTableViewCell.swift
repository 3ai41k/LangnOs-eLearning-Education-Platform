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
    var messageColor: UIColor { get }
}

typealias ChatMessageCellViewModelProtocol =
    ChatMessageCellViewModelInputProtocol &
    CellViewModelProtocol

final class ChatMessageTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 15.0
        }
    }
    @IBOutlet private weak var containerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ChatMessageCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        messageLabel.text = viewModel?.content
        messageLabel.textAlignment = viewModel?.textAlignment ?? .natural
        containerView.backgroundColor = viewModel?.messageColor
        
        if viewModel?.textAlignment == .left {
            containerViewTrailingConstraint.isActive = false
            containerViewTrailingConstraint = containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8.0)
            containerViewTrailingConstraint.isActive = true
            
            containerViewLeadingConstraint.isActive = false
            containerViewLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0)
            containerViewLeadingConstraint.isActive = true
        }
        
        if viewModel?.textAlignment == .right {
            containerViewLeadingConstraint.isActive = false
            containerViewLeadingConstraint = containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8.0)
            containerViewLeadingConstraint.isActive = true
            
            containerViewTrailingConstraint.isActive = false
            containerViewTrailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
            containerViewTrailingConstraint.isActive = true
        }
    }
    
}
