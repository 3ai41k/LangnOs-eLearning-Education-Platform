//
//  IncomingMessageFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 22.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class IncomingMessageFactory: ChatMessageAbstractFactoryProtocol {
    
    func createTextCell(message: Message) -> ChatMessageCellAppearenceProtocol {
        IncomingMessageCellViewModel(message: message)
    }
    
    func createPhotoCell(message: Message) -> ChatMessageCellAppearenceProtocol {
        PhotoIncomingMessageCellViewModel(message: message)
    }
    
    func createVocabularyCell(message: Message) -> ChatMessageCellAppearenceProtocol {
        VocabularyIncomingMessageCellViewModel(message: message)
    }
    
}
