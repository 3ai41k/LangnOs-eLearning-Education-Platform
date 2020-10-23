//
//  DashboardViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class DashboardViewController: BindibleViewController<DashboardViewModelProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            tableView.sectionFactory = sectionFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Publiec properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    var sectionFactory: SectionViewFactoryProtocol?
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.title.sink(receiveValue: { [weak self] (title) in
                self?.navigationController?.navigationBar.topItem?.title = title
            })
        ]
    }
    
    override func setupUI() {
        let createVocabularyButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                     target: self,
                                                     action: #selector(didCreateVocabularyTouch))
        
        navigationItem.rightBarButtonItem = createVocabularyButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Home".localize
    }
    
    // MARK: - Actions
    
    @objc
    private func didCreateVocabularyTouch() {
        viewModel?.actionSubject.send(.createVocabulary)
    }

}
