//
//  ChatCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ChatCoordinatorNavigationProtocol {
    func navigateToUserProfile()
    func showImagePicker(didImageSelect: @escaping (UIImage) -> Void)
    func navigateToVocabularyList()
}

typealias ChatCoordinatorProtocol =
    ChatCoordinatorNavigationProtocol &
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
        let dataProvider = FirebaseDatabase.shared
        let userSession = UserSession.shared
        let viewModel = ChatViewModel(router: self,
                                      chat: chat,
                                      dataProvider: dataProvider,
                                      userSession: userSession)
        
        let cellFactory = ChatCellFactory()
        let viewController = ChatViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        viewController.hidesBottomBarWhenPushed = true
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - ChatCoordinatorNavigationProtocol
    
    func navigateToUserProfile() {
        let coordinator = AccountCoordinator(parentViewController: parentViewController)
        coordinator.start()
    }
    
    func showImagePicker(didImageSelect: @escaping (UIImage) -> Void) {
        let coordinator = ImagePickerCoordinator(sourceType: .photoLibrary,
                                                 didImageSelect: didImageSelect,
                                                 parentViewController: viewController)
        coordinator.start()
    }
    
    func navigateToVocabularyList() {
        let coordinator = SearchVocabularyCoordinator(parentViewController: viewController)
        coordinator.start()
    }
    
}


