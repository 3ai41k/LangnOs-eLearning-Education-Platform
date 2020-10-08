//
//  CoursesCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class CoursesCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let coursesViewController = CoursesViewController()
        coursesViewController.tabBarItem = UITabBarItem(provider: .courses)
        
        let navigationController = UINavigationController(rootViewController: coursesViewController)
        viewController = navigationController
    }
    
}
