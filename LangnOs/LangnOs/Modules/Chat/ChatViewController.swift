//
//  ChatViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class ChatViewController: BindibleViewController<ChatViewModel> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsets(top: .zero,
                                                  left: .zero,
                                                  bottom: Constants.inputAccessoryViewHeight,
                                                  right: .zero)
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private properties
    
    private lazy var messageView: UIView = {
        let rect = CGRect(x: .zero,
                          y: .zero,
                          width: tableView.bounds.width,
                          height: Constants.inputAccessoryViewHeight)
        let view = MessageInputView(frame: rect)
        view.returnHandler = { [weak self] (text) in
            self?.viewModel?.send(message: text)
        }
        return view
    }()
    
    // MARK: - Override
    
    override var inputAccessoryView: UIView? {
        messageView
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func bindViewModel() {
        title = viewModel?.title
    }
    
}

// MARK: - Constants

extension ChatViewController {
    
    private enum Constants {
        static let inputAccessoryViewHeight: CGFloat = 52.0
    }
    
}

