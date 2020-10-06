//
//  FixedTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

typealias UniversalCollectionViewViewModel = UniversalSectionProtocol & UniversalCollectionViewOutputProtocol

final class UniversalCollectionView: UICollectionView {
    
    // MARK: - Private properties
    
    private var cancellable: [AnyCancellable] = []
    
    private var viewModel: UniversalCollectionViewViewModel! {
        didSet {
            viewModel.tableSections.enumerated().forEach({ (index, section) in
                section.reload.sink(receiveValue: { [weak self] in
                    self?.reloadSections([index])
                }).store(in: &cancellable)
            })
        }
    }
    private var cellFactory: UniversalCollectionViewCellFactoryProtocol! {
        didSet {
            cellFactory.registerAllCells(collectionView: self)
        }
    }
    private var layout: UniversalCollectionViewLayoutProtocol! {
        didSet {
            collectionViewLayout = layout.collectionViewLayout
        }
    }
    
    // MARK: - Public methods
    
    func start(viewModel: UniversalCollectionViewViewModel,
               cellFactory: UniversalCollectionViewCellFactoryProtocol,
               layout: UniversalCollectionViewLayoutProtocol) {
        self.viewModel = viewModel
        self.cellFactory = cellFactory
        self.layout = layout
        
        dataSource = self
        delegate = self
        
        reloadData()
    }
    
    // MARK: - Private methods
    
}

// MARK: - UICollectionViewDataSource

extension UniversalCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.tableSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.tableSections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.tableSections[indexPath.section].cells[indexPath.row]
        return cellFactory.generateCell(cellViewModel: cellViewModel, collectionView: collectionView, indexPath: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegate

extension UniversalCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCellAt(indexPath: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UniversalCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        layout.sizeForItemAt(collectionView, indexPath: indexPath)
    }
    
}
