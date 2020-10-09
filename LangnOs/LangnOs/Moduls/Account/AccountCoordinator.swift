//
//  AccountCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol AccountNavigationProtocol {
    func navigateToSingIn()
}

final class AccountCoordinator: Coordinator {
    
    // MARK: - Private methods
    
    private let context: AuthorizationContextProtocol = AuthorizationContext()
    
    // MARK: - Override
    
    override func start() {
        let authorizator = Authorizator()
        let accountViewModel = AccountViewModel(router: self, authorizator: authorizator, context: context)
        let accountViewController = AccountViewController()
        accountViewController.viewModel = accountViewModel
        accountViewController.tabBarItem = UITabBarItem(provider: .account)
        
        let navigationController = UINavigationController(rootViewController: accountViewController)
        viewController = navigationController
    }
    
}

// MARK: - AccountNavigationProtocol

extension AccountCoordinator: AccountNavigationProtocol {
    
    func navigateToSingIn() {
        let singInCoordinator = SingInCoordinator(context: context, parentViewController: viewController)
        singInCoordinator.start()
    }
    
}
