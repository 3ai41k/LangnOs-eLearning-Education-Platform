//
//  CreateVocabularyViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class CreateVocabularyViewController: BindibleViewController<CreateVocabularyViewModelInputProtocol & CreateVocabularyViewModelOutputProtocol & UniversalTableViewViewModel> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            guard let viewModel = viewModel, let cellFactory = tableViewCellFactory else { return }
            tableView.start(viewModel: viewModel, cellFactory: cellFactory)
        }
    }
    
    // MARK: - Public properties
    
    var tableViewCellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    
    override func bindViewModel() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
    @IBAction
    private func didAddNewRowTouched(_ sender: Any) {
        viewModel?.addRowAction()
    }
    
    

}
