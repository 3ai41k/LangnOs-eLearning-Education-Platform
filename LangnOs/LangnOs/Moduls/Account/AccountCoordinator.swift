//
//  AccountCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class AccountCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let accountViewController = AccountViewController()
        accountViewController.tabBarItem = UITabBarItem(provider: .account)
        
        let navigationController = UINavigationController(rootViewController: accountViewController)
        viewController = navigationController
    }
    
}
