//
//  MaterialsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class MaterialsViewController: BindibleViewController<MaterialsViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UniversalCollectionView! {
        didSet {
            let backgroundView = NoResulsView()
            backgroundView.title = "There aren't any materials.".localize
            
            collectionView.viewModel = viewModel
            collectionView.layout = layout
            collectionView.cellFactory = cellFactory
            collectionView.customBackgroundView = backgroundView
            
            collectionView.start()
        }
    }
    
    // MARK: - Public properties
    
    var layout: UniversalCollectionViewLayoutProtocol?
    var cellFactory: UniversalCollectionViewCellFactoryProtocol?
    
    // MARK: - Private properties
    
    private var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.actionSubject.send(.fetchData)
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.title.assign(to: \.title, on: self),
            viewModel?.scopeButtonTitles.assign(to: \.searchBar.scopeButtonTitles, on: searchController),
            viewModel?.isActivityIndicatorHidden.sink(receiveValue: { [weak self] (isHidden) in
                if isHidden {
                    let createVocabularyButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self?.didCreateVocabularyTouch))
                    
                    self?.navigationItem.rightBarButtonItem = createVocabularyButton
                } else {
                    let activityIndicatorView = UIActivityIndicatorView()
                    activityIndicatorView.startAnimating()
                    
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
                }
            })
        ]
    }
    
    override func configurateComponents() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    override func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Actions
    
    @objc
    private func didCreateVocabularyTouch() {
        viewModel?.actionSubject.send(.createVocabulary)
    }
    
}

// MARK: - UISearchResultsUpdating

extension MaterialsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel?.actionSubject.send(.search(text))
    }
    
}

// MARK: - UISearchBarDelegate

extension MaterialsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel?.actionSubject.send(.selectedScope(selectedScope))
    }
    
}

