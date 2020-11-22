//
//  ChatViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol ChatViewModelInputProtocol {
    var title: String { get }
}

protocol ChatViewModelOutputProtocol {
    func send(message: String)
    func userProfile()
    func sendFile()
    func finish()
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
    
    private let router: ChatCoordinatorProtocol
    private let chat: Chat
    private let dataProvider: FirebaseDatabaseCreatingProtocol & FirebaseDatabaseListeningProtocol
    private let userSession: SessionInfoProtocol
    
    private var listener: ListenerRegistration?
    private var messages: [Message] = [] {
        didSet {
            guard let currentUser = userSession.currentUser else { return }
            let cellViewModels: [CellViewModelProtocol] = messages.map({
                ChatMessageCellViewModel(currentUser: currentUser, message: $0)
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
        self.router = router
        self.chat = chat
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.appendMessageSection()
        
        self.listenMessages()
    }
    
    // MARK: - Public methods
    
    func send(message: String) {
        guard let userId = userSession.currentUser?.id else { return }
        
        let message = Message(userId: userId, content: message)
        let request = CreateMessageRequest(chatId: chat.id, message: message)
        dataProvider.create(request: request, onSuccess: {
            print("Success")
        }, onFailure: router.showError)
    }
    
    func userProfile() {
        router.navigateToUserProfile()
    }
    
    func sendFile() {
        router.showActionSheet(title: nil, message: nil, actions: [
            UIAlertAction(title: "Share vocabulary", style: .default, handler: { (_) in
                
            }),
            CancelAlertAction(handler: { })
        ])
    }
    
    //
    // NOTE:
    //
    // This method is needed to remove firestore listener. If you don't do it you will retain the insnstance of this module.
    // As you know, there is a problem with handling the back button of the navigation controller.
    // Because of this, view(UIViewController) must notify the viewModel to remove all dependencies.
    //
    
    func finish() {
        listener?.remove()
    }
    
    // MARK: - Private methods
    
    private func appendMessageSection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func listenMessages() {
        let request = FetchMessagesRequest(chatId: chat.id)
        listener = dataProvider.listen(request: request, onSuccess: { (messages: [Message]) in
            self.messages = messages
        }, onFailure: router.showError)
    }
    
}


