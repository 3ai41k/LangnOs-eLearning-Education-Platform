//
//  VocabularyListCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyListCoordinatorNavigationProtocol {
    
}

typealias VocabularyListCoordinatorProtocol =
    VocabularyListCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class VocabularyListCoordinator: Coordinator, VocabularyListCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = DataProvider()
        let securityManager = SecurityManager.shared
        let viewModel = VocabularyListViewModel(router: self,
                                                dataProvider: dataProvider,
                                                securityManager: securityManager)
        
        let cellFactory = VocabularyListCellFactory()
        let viewController = VocabularyListViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}


