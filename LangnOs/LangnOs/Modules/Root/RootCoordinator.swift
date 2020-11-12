//
//  RootCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol RootNavigationProtocol {
    func navigateToMaintenance()
}

typealias RootCoordinatorProtocol =
    RootNavigationProtocol &
    ActivityPresentableProtocol

final class RootCoordinator: Coordinator, RootCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let window: UIWindow
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parentViewController: nil)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = RootViewModel(router: self)
        let viewController = RootTabBarController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        
        window.rootViewController = viewController
        window.becomeKey()
    }
    
    // MARK: - RootNavigationProtocol
    
    func navigateToMaintenance() {
        let maintenanceCoordinator = MaintenanceCoordinator(parentViewController: viewController)
        maintenanceCoordinator.start()
    }
    
}
