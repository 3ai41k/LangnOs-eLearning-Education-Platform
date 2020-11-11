//
//  CellRegistratable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalCollectionViewCellRegistratable where Self: UICollectionViewCell {
    static var identifier: String { get }
    static var nib: UINib { get }
    static func register(_ collectionView: UICollectionView)
    static func dequeueReusableCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> Self
}

extension UniversalCollectionViewCellRegistratable {
    
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static func register(_ collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    static func dequeueReusableCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Self
    }
    
}
