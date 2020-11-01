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
            tableView.backgroundView = backgroundView
            tableView.tableFooterView = UIView()
            
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
    
    private let backgroundView: NoResulsView = {
        let backgroundView = NoResulsView()
        return backgroundView
    }()
    
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
        backgroundView.title = viewModel?.backgoundViewTitle
        searchController.searchBar.scopeButtonTitles = viewModel?.scopeButtonTitles
    }
    
    override func configurateComponents() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    override func setupUI() {
        navigationItem.searchController = searchController
    }
    
}

// MARK: - UISearchResultsUpdating

extension SearchVocabularyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel?.search(text: text)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchVocabularyViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel?.selectedScopeButtonFor(index: selectedScope)
    }
    
}

