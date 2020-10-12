//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MainNavigationProtocol {
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary)
    func navigateToFilter()
    func createNewVocabulary(didVocabularyCreateHandler: @escaping () -> Void)
    func navigateToSingIn()
}

typealias MainCoordinatorProtocol = MainNavigationProtocol & AlertPresentableProtocol

final class MainCoordinator: Coordinator, MainCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let firebaseDatabase = FirebaseDatabase()
        let coreDataContext = CoreDataContext()
        let reachability = Reachability()
        let dataFacade = DataFacade(firebaseDatabase: firebaseDatabase,
                                    coreDataContext: coreDataContext,
                                    reachability: reachability)
        
        let authorizator = Authorizator()
        let securityInfo = SecurityInfo()
        let mainViewModel = MainViewModel(router: self,
                                          userInfo: securityInfo,
                                          authorizator: authorizator,
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
    
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary, parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
    func navigateToFilter() {
        
    }
    
    func createNewVocabulary(didVocabularyCreateHandler: @escaping () -> Void) {
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
