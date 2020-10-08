//
//  MainSectionViewFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MainSectionViewFactory: UniversalCollectionViewSectionFactoryProtocol {
    
    private var viewTypes: [UniversalCollectionViewSectionRegistratable.Type] {
        [
            SearchBarCollectionReusableView.self
        ]
    }
    
    func registerAllViews(collectionView: UICollectionView) {
        viewTypes.forEach({ $0.register(collectionView) })
    }
    
    func generateView(sectionViewModel: CollectionReusableViewModelProtocol, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
        switch sectionViewModel {
        case let sectionViewModel as SearchBarCollectionReusableViewModel:
            let view = SearchBarCollectionReusableView.dequeueReusableView(collectionView, for: indexPath)
            view.viewModel = sectionViewModel
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
}
