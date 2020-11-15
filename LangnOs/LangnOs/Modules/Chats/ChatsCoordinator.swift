//
//  ChatsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ChatsCoordinatorNavigationProtocol {
    func navigateToChat(_ chat: Chat)
    func createChat()
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
    
    // MARK: - ChatsCoordinatorNavigationProtocol
    
    func navigateToChat(_ chat: Chat) {
        let chatCoordinator = ChatCoordinator(chat: chat, parentViewController: viewController)
        chatCoordinator.start()
    }
    
    func createChat() {
        let createChatCoordinator = CreateChatCoordinator(parentViewController: viewController)
        createChatCoordinator.start()
    }
    
}


