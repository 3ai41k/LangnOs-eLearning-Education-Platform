//
//  OutcomingMessageTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

enum ChatMessageAlignment {
    case left
    case right
    
    var stackViewAlignment: UIStackView.Alignment {
        switch self {
        case .left:
            return .leading
        case .right:
            return .trailing
        }
    }
}

protocol ChatMessageCellAppearenceProtocol {
    var content: String { get }
    var date: String { get }
    var alignment: ChatMessageAlignment { get }
    var backgroundColor: UIColor { get }
    var dateColor: UIColor { get }
    var hideButton: Bool { get }
    func buttonTouch()
}

extension ChatMessageCellAppearenceProtocol {
    func buttonTouch() { }
}

protocol ChatMessageCellViewModelInputProtocol {
    var appearence: ChatMessageCellAppearenceProtocol { get }
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
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var previewButton: UIButton!
    
    // MARK: - Public properties
    
    var viewModel: ChatMessageCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        messageLabel.text = viewModel?.appearence.content
        dateLabel.text = viewModel?.appearence.date
        dateLabel.textColor = viewModel?.appearence.dateColor
        stackView.alignment = viewModel?.appearence.alignment.stackViewAlignment ?? .fill
        containerView.backgroundColor = viewModel?.appearence.backgroundColor
        previewButton.isHidden = viewModel?.appearence.hideButton ?? true
        
        if viewModel?.appearence.alignment == .left {
            containerViewTrailingConstraint.isActive = false
            containerViewTrailingConstraint = containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8.0)
            containerViewTrailingConstraint.isActive = true
            
            containerViewLeadingConstraint.isActive = false
            containerViewLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0)
            containerViewLeadingConstraint.isActive = true
        }
        
        if viewModel?.appearence.alignment == .right {
            containerViewLeadingConstraint.isActive = false
            containerViewLeadingConstraint = containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8.0)
            containerViewLeadingConstraint.isActive = true
            
            containerViewTrailingConstraint.isActive = false
            containerViewTrailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
            containerViewTrailingConstraint.isActive = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didPreviewTouch(_ sender: Any) {
        viewModel?.appearence.buttonTouch()
    }
    
}
