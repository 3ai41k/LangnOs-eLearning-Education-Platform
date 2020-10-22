//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol DashboardNavigationProtocol {
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary, didVocabularyRemoveHandler: @escaping () -> Void)
    func navigateToFilter(selectedFilter: VocabularyFilter, selectFilterHandler: @escaping (VocabularyFilter) -> Void)
    func createNewVocabulary(user: User, didVocabularyCreateHandler: @escaping (Vocabulary) -> Void)
    func navigateToSingIn()
}

typealias DashboardCoordinatorProtocol = DashboardNavigationProtocol & AlertPresentableProtocol

final class DashboardCoordinator: Coordinator, DashboardCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let context: RootContextProtocol
    
    // MARK: - Init
    
    init(context: RootContextProtocol, parentViewController: UIViewController?) {
        self.context = context
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let securityManager = SecurityManager.shared
        let dataFacade = DataFacade()
        let viewModel = DashboardViewModel(router: self,
                                           contex: context,
                                           securityManager: securityManager,
                                           dataFacade: dataFacade)
        
        let viewController = DashboardViewController()
        viewController.viewModel = viewModel
        viewController.collectionViewCellFactory = DashboardCellFactory()
        viewController.collectionViewSectionFactory = DashboardSectionViewFactory()
        viewController.collectionViewLayout = SquareGridFlowLayout(numberOfItemsPerRow: 2)
        viewController.tabBarItem = UITabBarItem(provider: .dashboard)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController = navigationController
    }
    
    // MARK: - MainNavigationProtocol
    
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary, didVocabularyRemoveHandler: @escaping () -> Void) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary,
                                                          didVocabularyRemoveHandler: didVocabularyRemoveHandler,
                                                          parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
    func navigateToFilter(selectedFilter: VocabularyFilter, selectFilterHandler: @escaping (VocabularyFilter) -> Void) {
        let vocabularyFilterCoordinator = VocabularyFilterCoordinator(selectedFilter: selectedFilter,
                                                                      selectFilterHandler: selectFilterHandler,
                                                                      parentViewController: viewController)
        vocabularyFilterCoordinator.start()
    }
    
    func createNewVocabulary(user: User, didVocabularyCreateHandler: @escaping (Vocabulary) -> Void) {
        let createVocabularyCoordinator = CreateVocabularyCoordinator(user: user,
                                                                      didVocabularyCreateHandler: didVocabularyCreateHandler,
                                                                      parentViewController: viewController)
        createVocabularyCoordinator.start()
    }
    
    func navigateToSingIn() {
        let context = RootContext()
        let singInCoordinator = SingInCoordinator(context: context,
                                                  parentViewController: viewController)
        singInCoordinator.start()
    }
    
}
