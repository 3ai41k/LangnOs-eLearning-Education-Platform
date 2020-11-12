//
//  MaintenanceCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
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
        let dataSynchronizer = DataSynchronizer.shared
        let viewModel = MaintenanceViewModel(router: self,
                                             dataSynchronizer: dataSynchronizer)
        
        let viewController = MaintenanceViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: false, completion: nil)
    }
    
    // MARK: - CoordinatorClosableProtocol
    
    func close(completion: (() -> Void)?) {
        viewController?.dismiss(animated: false, completion: completion)
    }
    
}


