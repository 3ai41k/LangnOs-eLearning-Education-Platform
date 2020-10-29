//
//  MaintenanceCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MaintenanceCoordinatorNavigationProtocol {
    
}

typealias MaintenanceCoordinatorProtocol =
    MaintenanceCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class MaintenanceCoordinator: Coordinator, MaintenanceCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = MaintenanceViewModel()
        let viewController = MaintenanceViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
}


