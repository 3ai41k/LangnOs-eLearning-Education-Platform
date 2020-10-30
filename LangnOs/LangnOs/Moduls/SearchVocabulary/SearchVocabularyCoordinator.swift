//
//  SearchVocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol SearchVocabularyCoordinatorNavigationProtocol {
    
}

typealias SearchVocabularyCoordinatorProtocol =
    SearchVocabularyCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class SearchVocabularyCoordinator: Coordinator, SearchVocabularyCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = SearchVocabularyViewModel()
        let viewController = SearchVocabularyViewController()
        viewController.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(provider: .search)
        
        self.viewController = navigationController
    }
    
}


