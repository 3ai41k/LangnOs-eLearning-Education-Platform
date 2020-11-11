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
            tableView.cellFactory = cellFactory
            tableView.tableHeaderView = vocabularyInfoView
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private properties
    
    private let vocabularyInfoView: VocabularyInfoView = {
        let rect = CGRect(x: .zero, y: .zero, width: .zero, height: 220.0)
        let view = VocabularyInfoView(frame: rect)
        return view
    }()
    
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
        
        cancellables = [
            viewModel?.categoryButtonTitle.assign(to: \.selectButtonTitle, on: vocabularyInfoView)
        ]
        
        vocabularyInfoView.nameHandler = { [weak self] in
            self?.viewModel?.setVocabularyName($0)
        }
        vocabularyInfoView.selectCategoryHandler = { [weak self] in
            self?.viewModel?.selectCategory(sourceView: $0)
        }
        vocabularyInfoView.isPrivateOnHandler = { [weak self] in
            self?.viewModel?.setPrivate($0)
        }
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
        viewModel?.close()
    }
    
    @objc
    private func didDoneButtonTouch() {
        viewModel?.done()
    }

}
