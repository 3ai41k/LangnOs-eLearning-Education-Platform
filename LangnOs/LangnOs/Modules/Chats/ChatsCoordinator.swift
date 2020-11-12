//
//  ChatsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ChatsCoordinatorNavigationProtocol {
    
}

typealias ChatsCoordinatorProtocol =
    ChatsCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class ChatsCoordinator: Coordinator, ChatsCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = FirebaseDatabase.shared
        let viewModel = ChatsViewModel(router: self,
                                       dataProvider: dataProvider)
        
        let cellFactory = ChatsCellFactory()
        let viewController = ChatsViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(provider: .messages)
        
        self.viewController = navigationController
    }
    
}


