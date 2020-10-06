//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MainNavigationProtocol {
    func navigateToSingIn()
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary)
    func createNewVocabulary()
}

final class MainCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let firebaseDatabase = FirebaseDatabase()
        let mainViewModel = MainViewModel(router: self, firebaseDatabase: firebaseDatabase)
        let mainViewController = MainViewController()
        mainViewController.viewModel = mainViewModel
        mainViewController.collectionViewCellFactory = MainCellFactory()
        mainViewController.collectionViewLayout = SquareGridFlowLayout(numberOfItemsPerRow: 2)
        mainViewController.tabBarItem = UITabBarItem(provider: .main)
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        viewController = navigationController
    }
    
}

// MARK: - MainNavigationProtocol

extension MainCoordinator: MainNavigationProtocol {
    
    func navigateToSingIn() {
        let singInCoordinator = SingInCoordinator(parentViewController: viewController)
        singInCoordinator.start()
    }
    
    func navigateToVocabularyStatistic(_ vocabulary: Vocabulary) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary, parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
    func createNewVocabulary() {
        let createVocabularyCoordinator = CreateVocabularyCoordinator(parentViewController: viewController)
        createVocabularyCoordinator.start()
    }
    
}
