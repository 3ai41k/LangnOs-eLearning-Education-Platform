//
//  ChatCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ChatCoordinatorNavigationProtocol {
    
}

typealias ChatCoordinatorProtocol =
    ChatCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class ChatCoordinator: Coordinator, ChatCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let chat: Chat
    
    // MARK: - Init
    
    init(chat: Chat, parentViewController: UIViewController?) {
        self.chat = chat
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = ChatViewModel(router: self,
                                      chat: chat)
        
        let viewController = ChatViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}


