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
        if message.photoURL.isNotNil {
            return factory.createPhotoCell(message: message)
        } else if message.vocabularyId.isNotNil {
            return factory.createVocabularyCell(message: message)
        } else {
            return factory.createTextCell(message: message)
        }
    }
    
    // MARK: - Private properties
    
    private let factory: ChatMessageAbstractFactoryProtocol
    private let message: Message
    
    // MARK: - Init
    
    init(currentUser: User1, message: Message) {
        self.factory = currentUser.id == message.userId ?
            IncomingMessageFactory() :
            OutcomingMessageFactory()
        self.message = message
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
    
    var hideButton: Bool {
        true
    }
    
    internal let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    func buttonTouch() {
        
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
    
    var hideButton: Bool {
        true
    }
    
    internal let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    func buttonTouch() {
        
    }
    
}

final class PhotoIncomingMessageCellViewModel: IncomingMessageCellViewModel {
    
    
    
}

final class PhotoOutcomingMessageCellViewModel: OutcomingMessageCellViewModel {
    
    
    
}

final class VocabularyIncomingMessageCellViewModel: IncomingMessageCellViewModel {
    
    override var hideButton: Bool {
        false
    }
    
    override func buttonTouch() {
        
    }
    
}

final class VocabularyOutcomingMessageCellViewModel: OutcomingMessageCellViewModel {
    
    override var hideButton: Bool {
        false
    }
    
    override func buttonTouch() {
        
    }
    
}

