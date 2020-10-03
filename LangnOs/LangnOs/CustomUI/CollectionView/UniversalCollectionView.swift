//
//  FixedTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalCollectionViewViewModelProtocol: UniversalCollectionViewInputProtocol, UniversalCollectionViewBindingProtocol, UniversalCollectionViewOutputProtocol {

}

final class UniversalCollectionView: UICollectionView {
    
    // MARK: - Private properties
    
    private var viewModel: UniversalCollectionViewViewModelProtocol! {
        didSet {
            viewModel.reloadData = {
                self.reloadData()
            }
        }
    }
    private var cellFactory: UniversalCollectionViewCellFactoryProtocol! {
        didSet {
            cellFactory.registerAllCells(collectionView: self)
        }
    }
    
    // MARK: - Public methods
    
    func start(viewModel: UniversalCollectionViewViewModelProtocol,
               cellFactory: UniversalCollectionViewCellFactoryProtocol) {
        self.viewModel = viewModel
        self.cellFactory = cellFactory
        
        backgroundColor = viewModel.backgroundColor
        dataSource = self
        delegate = self
        
        reloadData()
    }
    
    // MARK: - Private methods
    
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

// MARK: - UICollectionViewDelegate

extension UniversalCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCellAt(indexPath: indexPath)
    }
    
}
