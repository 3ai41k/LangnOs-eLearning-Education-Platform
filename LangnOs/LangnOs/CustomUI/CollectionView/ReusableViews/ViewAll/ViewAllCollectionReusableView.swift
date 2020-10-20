//
//  ViewAllCollectionReusableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 20.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ViewAllCollectionReusableView: UICollectionReusableView, UniversalCollectionViewSectionRegistratable {
    
    static var kind: String {
        UICollectionView.elementKindSectionFooter
    }

    var viewModel: ViewAllCollectionReusableViewModelProtocol?
    
}
