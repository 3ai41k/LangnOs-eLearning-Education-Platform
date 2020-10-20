//
//  MainSectionViewFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MainSectionViewFactory: UniversalCollectionViewSectionFactoryProtocol {
    
    var viewTypes: [UniversalCollectionViewSectionRegistratable.Type] {
        [
            SearchBarCollectionReusableView.self,
            ViewAllCollectionReusableView.self
        ]
    }
    
    func generateView(reusableViewModel: CollectionReusableViewModelProtocol, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
        switch reusableViewModel {
        case let reusableViewModel as SearchBarCollectionReusableViewModel:
            let view = SearchBarCollectionReusableView.dequeueReusableView(collectionView, for: indexPath)
            view.viewModel = reusableViewModel
            return view
        case let reusableViewModel as ViewAllCollectionReusableViewModel:
            let view = ViewAllCollectionReusableView.dequeueReusableView(collectionView, for: indexPath)
            view.viewModel = reusableViewModel
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
}
