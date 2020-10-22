//
//  DashboardViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class DashboardViewController: BindibleViewController<DashboardViewModelProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UniversalCollectionView! {
        didSet {
            collectionView.viewModel = viewModel
            collectionView.cellFactory = collectionViewCellFactory
            collectionView.sectionFactory = collectionViewSectionFactory
            collectionView.layout = collectionViewLayout
            collectionView.customBackgroundView = NoResulsView()
            
            collectionView.start()
        }
    }
    
    // MARK: - Publiec properties
    
    var collectionViewCellFactory: UniversalCollectionViewCellFactoryProtocol?
    var collectionViewSectionFactory: UniversalCollectionViewSectionFactoryProtocol?
    var collectionViewLayout: UniversalCollectionViewLayoutProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.fetchData()
    }
    
    // MARK: - Override
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }

}
