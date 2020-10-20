//
//  StudyResultCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 20.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol StudyResultCoordinatorNavigationProtocol {
    
}

typealias StudyResultCoordinatorProtocol =
    StudyResultCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class StudyResultCoordinator: Coordinator, StudyResultCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = StudyResultViewModel(router: self)
        let viewController = StudyResultViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}


