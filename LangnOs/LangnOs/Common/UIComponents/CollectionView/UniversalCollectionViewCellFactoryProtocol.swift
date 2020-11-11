//
//  UniversalCollectionViewCellFactoryProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalCollectionViewCellFactoryProtocol {
    var cellTypes: [UniversalCollectionViewCellRegistratable.Type] { get }
    func generateCell(cellViewModel: CellViewModelProtocol, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

extension UniversalCollectionViewCellFactoryProtocol {
    
    func registerAllCells(collectionView: UICollectionView) {
        cellTypes.forEach({ $0.register(collectionView) })
    }
    
}
