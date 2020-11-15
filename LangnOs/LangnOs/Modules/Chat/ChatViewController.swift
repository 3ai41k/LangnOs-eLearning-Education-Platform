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
        view.paperclipHandler = { [weak self] in
            self?.viewModel?.sendFile()
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
    
    override func setupUI() {
        setupUserBarButtonItem()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            viewModel?.finish()
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
                    if height != Constants.inputAccessoryViewHeight {
                        self?.tableView.scrollToBottom(animated: true)
                    }
                })
        ]
    }
    
    private func setupUserBarButtonItem() {
        let userBarButtonItem = UIBarButtonItem(image: SFSymbols.personCircle(),
                                                style: .plain,
                                                target: self,
                                                action: #selector(didUserTouch))
        navigationItem.rightBarButtonItem = userBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc
    private func didUserTouch() {
        viewModel?.userProfile()
    }
    
}

// MARK: - Constants

extension ChatViewController {
    
    private enum Constants {
        static let inputAccessoryViewHeight: CGFloat = 52.0
    }
    
}

