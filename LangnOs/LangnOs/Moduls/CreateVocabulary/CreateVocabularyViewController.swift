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
        title = viewModel?.title
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
        
        setupVocabularyInfoView()
    }
    
    // MARK: - Private methods
    
    private func setupVocabularyInfoView() {
        let rect = CGRect(x: .zero, y: .zero, width: .zero, height: 220.0)
        let view = VocabularyInfoView(frame: rect)
        view.nameHandler = { [weak self] in
            self?.viewModel?.setVocabularyName($0)
        }
        view.selectCategoryHandler = { [weak self] in
            self?.viewModel?.selectCategory(sourceView: $0)
        }
        view.isPrivateOnHandler = { [weak self] in
            self?.viewModel?.setPrivate($0)
        }
        
        tableView.tableHeaderView = view
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
