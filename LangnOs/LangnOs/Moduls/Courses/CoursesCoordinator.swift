//
//  CoursesCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 31.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CoursesCoordinatorNavigationProtocol {
    
}

typealias CoursesCoordinatorProtocol =
    CoursesCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class CoursesCoordinator: Coordinator, CoursesCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = CoursesViewModel()
        let viewController = CoursesViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
    }
    
}


