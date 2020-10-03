//
//  UniversalCollectionViewInputProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol UniversalCollectionViewInputProtocol {
    var numberOfItemsInSection: Int { get }
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol
}
