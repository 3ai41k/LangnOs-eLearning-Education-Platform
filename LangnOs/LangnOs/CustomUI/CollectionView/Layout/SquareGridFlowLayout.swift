//
//  SquareGridFlowLayout.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class SquareGridFlowLayout {
    
    // MARK: - Private properties
    
    private let numberOfItemsPerRow: CGFloat
    
    // MARK: - Init
    
    init(numberOfItemsPerRow: Int) {
        self.numberOfItemsPerRow = CGFloat(numberOfItemsPerRow)
    }
    
}

// MARK: - UniversalCollectionViewLayoutProtocol

extension SquareGridFlowLayout: UniversalCollectionViewLayoutProtocol {
    
    var collectionViewLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(equal: Constants.spacing)
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
        layout.headerReferenceSize = CGSize(width: .zero, height: 54.0)
        layout.footerReferenceSize = CGSize(width: .zero, height: 54.0)
        return layout
    }
    
    func sizeForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * Constants.spacing) + ((numberOfItemsPerRow - 1) * Constants.spacingBetweenCells)
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: 300.0)
    }
    
}

// MARK: - Constants

extension SquareGridFlowLayout {
    
    private enum Constants {
        static var spacing: CGFloat = 8.0
        static var spacingBetweenCells: CGFloat = 8.0
    }
    
}
