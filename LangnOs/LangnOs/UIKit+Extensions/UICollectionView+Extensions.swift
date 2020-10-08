//
//  UICollectionView+Extensions.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func reloadItems(inSection section:Int) {
       reloadItems(at: (0..<numberOfItems(inSection: section)).map {
          IndexPath(item: $0, section: section)
       })
    }
    
}
