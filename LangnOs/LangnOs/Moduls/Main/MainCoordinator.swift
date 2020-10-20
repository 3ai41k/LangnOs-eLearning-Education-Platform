//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol MainNavigationProtocol {
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary, didVocabularyRemoveHandler: @escaping () -> Void)
    func navigateToFilter(didVocabularyFilerSelece: @escaping () -> Void)
    func createNewVocabulary(user: User, didVocabularyCreateHandler: @escaping (Vocabulary) -> Void)
    func navigateToSingIn()
}

typealias MainCoordinatorProtocol = MainNavigationProtocol & AlertPresentableProtocol

final class MainCoordinator: Coordinator, MainCoordinatorProtocol {
    
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
        let coreDataContext = CoreDataContext()
        let dataFacade = DataFacade()
        let mainViewModel = MainViewModel(router: self,
                                          contex: context,
                                          securityManager: securityManager,
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
    
    func navigateToFilter(didVocabularyFilerSelece: @escaping () -> Void) {
        let vocabularyFilterCoordinator = VocabularyFilterCoordinator(didVocabularyFilerSelece: didVocabularyFilerSelece,
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
        let singInCoordinator = SingInCoordinator(context: context, parentViewController: viewController)
        singInCoordinator.start()
    }
    
}
