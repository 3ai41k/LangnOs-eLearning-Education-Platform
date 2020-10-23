//
//  MaterialsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

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
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Init
    
    
    
    
    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    override func setupUI() {
        let searchController = UISearchController()
        
        navigationItem.searchController = searchController
        title = "Materials".localize
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    
    
    
    
    // MARK: - Private methods
    
    
    
    // MARK: - Actions
    
}

