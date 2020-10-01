//
//  RootCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class RootCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private let window: UIWindow
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parentViewController: nil)
    }
    
    // MARK: - Override
    
    override func start() {
        let tabBarViewModel = RootViewModel()
        let tabBarController = RootTabBarController()
        tabBarController.viewModel = tabBarViewModel
        
        window.rootViewController = tabBarController
        window.becomeKey()
    }
    
}
