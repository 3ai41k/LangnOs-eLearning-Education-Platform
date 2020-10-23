//
//  MaterialsCellFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MaterialsCellFactory: UniversalCollectionViewCellFactoryProtocol {
    
    var cellTypes: [UniversalCollectionViewCellRegistratable.Type] {
        [
            VocabularyCollectionViewCell.self
        ]
    }
    
    func generateCell(cellViewModel: CellViewModelProtocol, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch cellViewModel {
        case let cellViewModel as VocabularyCollectionViewCellViewModel:
            let cell = VocabularyCollectionViewCell.dequeueReusableCell(collectionView, for: indexPath)
            cell.viewModel = cellViewModel
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}
