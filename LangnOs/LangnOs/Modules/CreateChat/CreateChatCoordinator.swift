//
//  CreateChatCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 15.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CreateChatCoordinatorNavigationProtocol {
    
}

typealias CreateChatCoordinatorProtocol =
    CreateChatCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class CreateChatCoordinator: Coordinator, CreateChatCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = CreateChatViewModel()
        let viewController = CreateChatViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
}


