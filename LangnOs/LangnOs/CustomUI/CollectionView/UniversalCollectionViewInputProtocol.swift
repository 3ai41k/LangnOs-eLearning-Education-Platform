//
//  UniversalCollectionViewInputProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalCollectionDataSourceProtocol {
    var numberOfItemsInSection: Int { get }
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol
}

protocol UniversalCollectionViewInputProtocol: UniversalCollectionDataSourceProtocol {
    var backgroundColor: UIColor { get }
}

extension UniversalCollectionViewInputProtocol {
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
