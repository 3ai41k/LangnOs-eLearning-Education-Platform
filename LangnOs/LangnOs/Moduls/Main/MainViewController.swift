//
//  MainViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

typealias MainViewModelType = MainViewModelInputProtocol & MainViewModelOutputProtocol & UniversalCollectionViewViewModel

final class MainViewController: BindibleViewController<MainViewModelType> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var fiexedCollectionView: UniversalCollectionView! {
        didSet {
            fiexedCollectionView.viewModel = viewModel
            fiexedCollectionView.cellFactory = collectionViewCellFactory
            fiexedCollectionView.sectionFactory = collectionViewSectionFactory
            fiexedCollectionView.layout = collectionViewLayout
            fiexedCollectionView.refreshDataHandler = viewModel?.refreshData
            
            fiexedCollectionView.start()
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
