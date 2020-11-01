//
//  SearchVocabularyViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class SearchVocabularyViewController: BindibleViewController<SearchVocabularyViewModelPrtotocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private properties
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    override func configurateComponents() {
        searchController.searchResultsUpdater = self
    }
    
    override func setupUI() {
        title = viewModel?.title
        navigationItem.searchController = searchController
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
}

// MARK: - UISearchResultsUpdating

extension SearchVocabularyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel?.search(text: text)
    }
    
}

