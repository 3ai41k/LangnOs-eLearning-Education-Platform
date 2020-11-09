//
//  MessagesCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MessagesCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let viewController = MessagesViewController()
        viewController.tabBarItem = UITabBarItem(provider: .messages)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController = navigationController
    }
    
}
