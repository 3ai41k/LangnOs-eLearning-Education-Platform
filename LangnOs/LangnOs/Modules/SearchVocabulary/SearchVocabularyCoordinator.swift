//
//  SearchVocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol SearchVocabularyCoordinatorNavigationProtocol {
    func navigateToVocabularyPreview(_ vocabulary: Vocabulary)
}

typealias SearchVocabularyCoordinatorProtocol =
    SearchVocabularyCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class SearchVocabularyCoordinator: Coordinator, SearchVocabularyCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = FirebaseDatabase.shared
        let userSeession = UserSession.shared
        let storage = FirebaseStorage()
        let viewModel = SearchVocabularyViewModel(router: self,
                                                  dataProvider: dataProvider,
                                                  storage: storage,
                                                  userSession: userSeession)
        
        let cellFactory = SeachVocabularyCellFactory()
        let viewController = SearchVocabularyViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(provider: .search)
        
        self.viewController = navigationController
    }
    
    // MARK: - SearchVocabularyCoordinatorNavigationProtocol
    
    func navigateToVocabularyPreview(_ vocabulary: Vocabulary) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary, parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
}


