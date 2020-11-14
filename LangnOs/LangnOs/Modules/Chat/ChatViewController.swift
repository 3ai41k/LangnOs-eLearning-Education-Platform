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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
    }
    
    // MARK: - Override
    
    override var inputAccessoryView: UIView? {
        messageView
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func bindViewModel() {
        title = viewModel?.title
        viewModel?.scrollToBottom = { [weak self] in
            self?.tableView.scrollToBottom(animated: false)
        }
    }
    
    // MARK: - Private methods
    
    private func setupNotifications() {
        cancellables = [
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap({ $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue })
                .map({ $0.cgRectValue.height })
                .sink(receiveValue: { [weak self] (height) in
                    self?.tableView.contentInset = UIEdgeInsets(top: .zero,
                                                                left: .zero,
                                                                bottom: height,
                                                                right: .zero)
                    self?.tableView.scrollToBottom(animated: true)
                }),
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .sink(receiveValue: { [weak self] (_) in
                    self?.tableView.contentInset = UIEdgeInsets(top: .zero,
                                                                left: .zero,
                                                                bottom: Constants.inputAccessoryViewHeight,
                                                                right: .zero)
                })
        ]
    }
    
}

// MARK: - Constants

extension ChatViewController {
    
    private enum Constants {
        static let inputAccessoryViewHeight: CGFloat = 52.0
    }
    
}

