//
//  ChatsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ChatsViewController: BindibleViewController<ChatsViewModel> {
    
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
    
    // MARK: - Override
    
    override func bindViewModel() {
        navigationController?.navigationBar.topItem?.title = viewModel?.title
    }
    
    override func setupUI() {
        setupEditBarButtonItem()
        setupCreateChatBarButtonItem()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - Private methods
    
    private func setupEditBarButtonItem() {
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func setupCreateChatBarButtonItem() {
        let createChatBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                      target: self,
                                                      action: #selector(createChatTouch))
        navigationItem.rightBarButtonItem = createChatBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc
    private func createChatTouch() {
        viewModel?.createChat()
    }
    
}

