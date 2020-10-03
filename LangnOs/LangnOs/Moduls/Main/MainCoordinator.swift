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
}

final class MainCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let cloudFirestore = FirebaseDatabase()
        let mainViewModel = MainViewModel(router: self, cloudFirestore: cloudFirestore)
        let mainViewController = MainViewController()
        mainViewController.viewModel = mainViewModel
        mainViewController.collectionViewCellFactory = MainCellFactory()
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
    
}
