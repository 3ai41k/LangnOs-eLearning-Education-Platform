//
//  WordsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class WordsViewController: BindibleViewController<WordsViewModelInputProtocol & WordsViewModelOutputProtocol & UniversalTableViewModelProtocol> {
    
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
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions

}
