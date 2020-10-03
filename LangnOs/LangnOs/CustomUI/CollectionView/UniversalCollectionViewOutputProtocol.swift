//
//  UniversalCollectionViewOutputProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol UniversalCollectionViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath)
}

extension UniversalCollectionViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath) { }
}
