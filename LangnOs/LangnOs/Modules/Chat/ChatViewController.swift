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
    @IBOutlet weak var messageTextField: UITextField!
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didSendTouch(_ sender: Any) {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        viewModel?.send(message: text)
    }
    
}

