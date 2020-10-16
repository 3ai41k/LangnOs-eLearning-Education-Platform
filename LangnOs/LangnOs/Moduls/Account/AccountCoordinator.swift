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
    func navigateToPresention()
}

final class AccountCoordinator: Coordinator {
    
    // MARK: - Private methods
    
    private let context: RootContextProtocol
    
    // MARK: - Init
    
    init(context: RootContextProtocol, parentViewController: UIViewController?) {
        self.context = context
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let securityManager = SecurityManager.shared
        let authorizator = Authorizator()
        let accountViewModel = AccountViewModel(router: self,
                                                context: context,
                                                securityManager: securityManager,
                                                authorizator: authorizator)
        
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
    
    func navigateToPresention() {
        let presentationCoordinator = PresentationCoordinator(parentViewController: viewController)
        presentationCoordinator.start()
    }
    
}
