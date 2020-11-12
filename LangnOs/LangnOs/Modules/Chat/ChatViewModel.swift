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
    func send(message: String)
}

typealias ChatViewModelProtocol =
    ChatViewModelInputProtocol &
    ChatViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case messages
}

final class ChatViewModel: ChatViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        chat.name
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: ChatCoordinatorProtocol
    private let chat: Chat
    private let dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol
    private let userSession: SessionInfoProtocol
    
    private var messages: [Message] = [] {
        didSet {
            let cellViewModels: [CellViewModelProtocol] = messages.map({
                if $0.userId == self.userSession.currentUser?.id {
                    return OutcomingMessageCellViewModel(message: $0)
                } else {
                    return IncomingMessageCellViewModel(message: $0)
                }
            })
            tableSections[SectionType.messages.rawValue].cells.value = cellViewModels
        }
    }
    
    // MARK: - Init
    
    init(router: ChatCoordinatorProtocol,
         chat: Chat,
         dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.chat = chat
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.appendMessageSection()
        
        self.fetchData()
    }
    
    // MARK: - Public methods
    
    func send(message: String) {
        guard let userId = userSession.currentUser?.id else { return }
        
        let message = Message(userId: userId, content: message)
        let request = CreateMessageRequest(chatId: chat.id, message: message)
        dataProvider.create(request: request, onSuccess: {
            self.messages.append(message)
        }, onFailure: router.showError)
    }
    
    // MARK: - Private methods
    
    private func appendMessageSection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func fetchData() {
        let request = FetchMessagesRequest(chatId: chat.id)
        dataProvider.fetch(request: request, onSuccess: { (messages: [Message]) in
            self.messages = messages
        }, onFailure: router.showError)
    }
    
}


