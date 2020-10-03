//
//  MainViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MainViewController: BindibleViewController<MainViewModelInputProtocol & UniversalCollectionViewInputProtocol & MainViewModelOutputProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var fiexedCollectionView: UniversalCollectionView! {
        didSet {
            guard let viewModel = viewModel, let cellFactory = collectionViewCellFactory else { return }
            fiexedCollectionView.start(viewModel: viewModel, cellFactory: cellFactory)
        }
    }
    
    // MARK: - Publiec properties
    
    var collectionViewCellFactory: UniversalCollectionViewCellFactoryProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponents()
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Private methods
    
    private func initializeComponents() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }

}
