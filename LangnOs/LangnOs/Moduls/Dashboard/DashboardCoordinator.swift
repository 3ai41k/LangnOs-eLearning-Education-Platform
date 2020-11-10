//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol DashboardNavigationProtocol {
    func navigateToUserProfile()
    func navigateToLogin()
    func navigateToMaterials()
    func navigateToVocabulary(_ vocabulary: Vocabulary)
    func navigateToVocabularyList(addVocabularyHandler: @escaping (Vocabulary) -> Void,
                                  removeVocabularyHandler: @escaping (Vocabulary) -> Void)
}

typealias DashboardCoordinatorProtocol = DashboardNavigationProtocol & AlertPresentableProtocol

final class DashboardCoordinator: Coordinator, DashboardCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let userSession = UserSession.shared
        let dataProvider = DataProvider(firebaseDatabase: FirebaseDatabase.shared)
        let storage = UserStorage(storage: FirebaseStorage())
        let viewModel = DashboardViewModel(router: self,
                                           userSession: userSession,
                                           dataProvider: dataProvider,
                                           storage: storage)
        
        let cellFactory = DashboardCellFactory()
        let sectionFactory = DashboardSectionFactory()
        let viewController = DashboardViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        viewController.sectionFactory = sectionFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(provider: .dashboard)
        
        self.viewController = navigationController
    }
    
    // MARK: - MainNavigationProtocol
    
    func navigateToUserProfile() {
        let accountCoordinator = AccountCoordinator(parentViewController: viewController)
        accountCoordinator.start()
    }
    
    func navigateToLogin() {
        let singInCoordinator = SingInCoordinator(parentViewController: viewController)
        singInCoordinator.start()
    }
    
    func navigateToMaterials() {
        let materialsCoordinator = MaterialsCoordinator(parentViewController: viewController)
        materialsCoordinator.start()
    }
    
    func navigateToVocabulary(_ vocabulary: Vocabulary) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary, parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
    func navigateToVocabularyList(addVocabularyHandler: @escaping (Vocabulary) -> Void, removeVocabularyHandler: @escaping (Vocabulary) -> Void) {
        let vocabularyListCoordinator = VocabularyListCoordinator(addVocabularyHandler: addVocabularyHandler,
                                                                  removeVocabularyHandler: removeVocabularyHandler,
                                                                  parentViewController: viewController)
        vocabularyListCoordinator.start()
    }
    
}
