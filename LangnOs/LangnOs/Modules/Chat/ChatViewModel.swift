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

protocol ChatViewModelBindingProtocol {
    var scrollToBottom: (() -> Void)? { get set }
}

typealias ChatViewModelProtocol =
    ChatViewModelInputProtocol &
    ChatViewModelOutputProtocol &
    ChatViewModelBindingProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case messages
}

final class ChatViewModel: ChatViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        chat.name
    }
    
    var scrollToBottom: (() -> Void)?
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    // let router: ChatCoordinatorProtocol
    private let chat: Chat
    private let dataProvider: FirebaseDatabaseCreatingProtocol & FirebaseDatabaseListeningProtocol
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
            scrollToBottom?()
        }
    }
    
    // MARK: - Init
    
    init(router: ChatCoordinatorProtocol,
         chat: Chat,
         dataProvider: FirebaseDatabaseCreatingProtocol & FirebaseDatabaseListeningProtocol,
         userSession: SessionInfoProtocol) {
        //self.router = router
        self.chat = chat
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.appendMessageSection()
        
        self.listenMessages()
    }
    
    // MARK: - Public methods
    
    // TO DO: Fix retain cycle
    
    func send(message: String) {
        guard let userId = userSession.currentUser?.id else { return }
        
        let message = Message(userId: userId, content: message)
        let request = CreateMessageRequest(chatId: chat.id, message: message)
        dataProvider.create(request: request, onSuccess: {
            print("Success")
        }, onFailure: { (error) in
            //self.router.showError(error)
        })
    }
    
    // MARK: - Private methods
    
    private func appendMessageSection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func listenMessages() {
        let request = FetchMessagesRequest(chatId: chat.id)
        dataProvider.listen(request: request, onSuccess: { (messages: [Message]) in
            self.messages = messages
        }, onFailure: { (error) in
            //self.router.showError(error)
        })
    }
    
}


