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
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.actionSubject.send(.fetchData)
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
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
    
    override func setupUI() {
        let searchController = UISearchController()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        title = "Materials".localize
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    
    
    
    
    // MARK: - Private methods
    
    
    
    // MARK: - Actions
    
    @objc
    private func didCreateVocabularyTouch() {
        viewModel?.actionSubject.send(.createVocabulary)
    }
    
}

