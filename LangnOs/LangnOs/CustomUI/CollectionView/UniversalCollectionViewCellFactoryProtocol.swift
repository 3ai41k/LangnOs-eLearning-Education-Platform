//
//  UniversalCollectionViewCellFactoryProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalCollectionViewCellFactoryProtocol {
    func registerAllCells(collectionView: UICollectionView)
    func generateCell(cellViewModel: CellViewModelProtocol, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
