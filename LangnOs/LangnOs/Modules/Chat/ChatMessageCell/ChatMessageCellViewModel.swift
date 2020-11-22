//
//  OutcomingMessageCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ChatMessageCellViewModel: ChatMessageCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var appearence: ChatMessageCellAppearenceProtocol {
        ChatMessageAbstractFactory(currentUser: currentUser).create(message: message, type: .text)
    }
    
    // MARK: - Private properties
    
    private let currentUser: User1
    private let message: Message
    
    // MARK: - Init
    
    init(currentUser: User1, message: Message) {
        self.currentUser = currentUser
        self.message = message
    }
    
}

enum ChatMessageType {
    case text
    case photo
    case vocabulary
}

protocol ChatMessageAbstractFactoryProtocol {
    func create(message: Message, type: ChatMessageType) -> ChatMessageCellAppearenceProtocol
}

final class IncomingMessageFactory: ChatMessageAbstractFactoryProtocol {
    
    func create(message: Message, type: ChatMessageType) -> ChatMessageCellAppearenceProtocol {
        switch type {
        case .text:
            return IncomingMessageCellViewModel(message: message)
        case .photo:
            return IncomingMessageCellViewModel(message: message)
        case .vocabulary:
            return IncomingMessageCellViewModel(message: message)
        }
    }
    
}

final class OutcomingMessageFactory: ChatMessageAbstractFactoryProtocol {
    
    func create(message: Message, type: ChatMessageType) -> ChatMessageCellAppearenceProtocol {
        switch type {
        case .text:
            return OutcomingMessageCellViewModel(message: message)
        case .photo:
            return OutcomingMessageCellViewModel(message: message)
        case .vocabulary:
            return OutcomingMessageCellViewModel(message: message)
        }
    }
    
}

final class ChatMessageAbstractFactory: ChatMessageAbstractFactoryProtocol {
    
    private let currentUser: User1
    
    init(currentUser: User1) {
        self.currentUser = currentUser
    }
    
    func create(message: Message, type: ChatMessageType) -> ChatMessageCellAppearenceProtocol {
        if currentUser.id == message.id {
            return IncomingMessageFactory().create(message: message, type: type)
        } else {
            return OutcomingMessageFactory().create(message: message, type: type)
        }
    }
    
}

class IncomingMessageCellViewModel: ChatMessageCellAppearenceProtocol {
    
    var content: String {
        message.content
    }
    
    var date: String {
        message.createdDate.format(type: .HHmm)
    }
    
    var alignment: ChatMessageAlignment {
        .left
    }
    
    var backgroundColor: UIColor {
        .systemGray6
    }
    
    var dateColor: UIColor {
        .systemGray2
    }
    
    private let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
}

class OutcomingMessageCellViewModel: ChatMessageCellAppearenceProtocol {
    
    var content: String {
        message.content
    }
    
    var date: String {
        message.createdDate.format(type: .HHmm)
    }
    
    var alignment: ChatMessageAlignment {
        .right
    }
    
    var backgroundColor: UIColor {
        .systemBlue
    }
    
    var dateColor: UIColor {
        .systemGray6
    }
    
    private let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
}

