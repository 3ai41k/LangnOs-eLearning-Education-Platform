//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MainNavigationProtocol {
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary, didVocabularyRemoveHandler: @escaping () -> Void)
    func navigateToFilter(didVocabularyFilerSelece: @escaping (VocabularyFilter) -> Void)
    func createNewVocabulary(didVocabularyCreateHandler: @escaping (Vocabulary) -> Void)
    func navigateToSingIn()
}

typealias MainCoordinatorProtocol = MainNavigationProtocol & AlertPresentableProtocol

final class MainCoordinator: Coordinator, MainCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let authorizator = Authorizator()
        let securityInfo = SecurityInfo()
        let coreDataContext = CoreDataContext()
        let dataFacade = DataFacade()
        let mainViewModel = MainViewModel(router: self,
                                          userInfo: securityInfo,
                                          authorizator: authorizator,
                                          coreDataContext: coreDataContext,
                                          dataFacade: dataFacade)
        
        let mainViewController = MainViewController()
        mainViewController.viewModel = mainViewModel
        mainViewController.collectionViewCellFactory = MainCellFactory()
        mainViewController.collectionViewSectionFactory = MainSectionViewFactory()
        mainViewController.collectionViewLayout = SquareGridFlowLayout(numberOfItemsPerRow: 2)
        mainViewController.tabBarItem = UITabBarItem(provider: .main)
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        viewController = navigationController
    }
    
    // MARK: - MainNavigationProtocol
    
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary, didVocabularyRemoveHandler: @escaping () -> Void) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary,
                                                          didVocabularyRemoveHandler: didVocabularyRemoveHandler,
                                                          parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
    func navigateToFilter(didVocabularyFilerSelece: @escaping (VocabularyFilter) -> Void) {
        let vocabularyFilterCoordinator = VocabularyFilterCoordinator(didVocabularyFilerSelece: didVocabularyFilerSelece,
                                                                      parentViewController: viewController)
        vocabularyFilterCoordinator.start()
    }
    
    func createNewVocabulary(didVocabularyCreateHandler: @escaping (Vocabulary) -> Void) {
        let createVocabularyCoordinator = CreateVocabularyCoordinator(didVocabularyCreateHandler: didVocabularyCreateHandler,
                                                                      parentViewController: viewController)
        createVocabularyCoordinator.start()
    }
    
    func navigateToSingIn() {
        let context = AuthorizationContext()
        let singInCoordinator = SingInCoordinator(context: context, parentViewController: viewController)
        singInCoordinator.start()
    }
    
}
