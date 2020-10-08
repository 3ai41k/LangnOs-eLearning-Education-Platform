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
        let messagesViewController = MessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(provider: .messages)
        
        let navigationController = UINavigationController(rootViewController: messagesViewController)
        viewController = navigationController
    }
    
}
