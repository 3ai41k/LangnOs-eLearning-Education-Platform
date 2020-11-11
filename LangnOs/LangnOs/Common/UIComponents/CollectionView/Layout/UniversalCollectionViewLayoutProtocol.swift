//
//  UniversalCollectionViewLayoutProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalCollectionViewLayoutProtocol {
    var collectionViewLayout: UICollectionViewFlowLayout { get }
    func sizeForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> CGSize
}
