//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(provider: .main)
        
        viewController = mainViewController
    }
    
}
