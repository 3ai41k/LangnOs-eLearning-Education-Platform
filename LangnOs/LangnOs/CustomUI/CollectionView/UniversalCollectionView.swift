//
//  FixedTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class UniversalCollectionView: UICollectionView {
    
    // MARK: - Private properties
    
    private var viewModel: UniversalCollectionViewInputProtocol!
    private var cellFactory: UniversalCollectionViewCellFactoryProtocol! {
        didSet {
            cellFactory.registerAllCells(collectionView: self)
        }
    }
    
    // MARK: - Public methods
    
    func start(viewModel: UniversalCollectionViewInputProtocol, cellFactory: UniversalCollectionViewCellFactoryProtocol) {
        self.viewModel = viewModel
        self.cellFactory = cellFactory
        
        dataSource = self
        
        reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource

extension UniversalCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellViewModelForRowAt(indexPath: indexPath)
        return cellFactory.generateCell(cellViewModel: cellViewModel, collectionView: collectionView, indexPath: indexPath)
    }
    
}
