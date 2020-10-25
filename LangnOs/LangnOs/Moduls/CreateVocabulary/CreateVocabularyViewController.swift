//
//  CreateVocabularyViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class CreateVocabularyViewController: BindibleViewController<CreateVocabularyViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = tableViewCellFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var tableViewCellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.title.sink(receiveValue: { [weak self] (title) in
                self?.title = title
            })
        ]
    }
    
    override func setupUI() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didCloseButtonTouch))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didDoneButtonTouch))
        
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.leftBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseButtonTouch() {
        viewModel?.closeAction()
    }
    
    @objc
    private func didDoneButtonTouch() {
        viewModel?.doneAction()
    }

}
