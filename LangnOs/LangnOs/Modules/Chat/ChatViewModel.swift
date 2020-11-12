//
//  ChatViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol ChatViewModelInputProtocol {
    var title: String { get }
}

protocol ChatViewModelOutputProtocol {
    
}

typealias ChatViewModelProtocol =
    ChatViewModelInputProtocol &
    ChatViewModelOutputProtocol

final class ChatViewModel: ChatViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        chat.name
    }
    
    // MARK: - Private properties
    
    private let router: ChatCoordinatorProtocol
    private let chat: Chat
    
    // MARK: - Init
    
    init(router: ChatCoordinatorProtocol,
         chat: Chat) {
        self.router = router
        self.chat = chat
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
}


