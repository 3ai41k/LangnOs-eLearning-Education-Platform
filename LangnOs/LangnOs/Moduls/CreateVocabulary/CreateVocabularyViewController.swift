//
//  CreateVocabularyViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class CreateVocabularyViewController: BindibleViewController<CreateVocabularyViewModelInputProtocol & UniversalTableViewSectionProtocol> {
    
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
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    
    // MARK: - Init
    // MARK: - Override
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    

}
