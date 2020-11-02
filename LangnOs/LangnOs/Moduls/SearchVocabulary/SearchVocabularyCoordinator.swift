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
        let firebaseDatabase = FirebaseDatabase.shared
        let userSeession = UserSession.shared
        let viewModel = SearchVocabularyViewModel(router: self,
                                                  firebaseDatabase: firebaseDatabase,
                                                  userSession: userSeession)
        
        let cellFactory = VocabularyListCellFactory()
        let viewController = SearchVocabularyViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(provider: .search)
        
        self.viewController = navigationController
    }
    
}


