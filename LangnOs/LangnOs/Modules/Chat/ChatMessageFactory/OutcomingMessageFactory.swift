//
//  OutcomingMessageFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 22.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class OutcomingMessageFactory: ChatMessageAbstractFactoryProtocol {
    
    func createTextCell(message: Message) -> ChatMessageCellAppearenceProtocol {
        OutcomingMessageCellViewModel(message: message)
    }
    
    func createPhotoCell(message: Message) -> ChatMessageCellAppearenceProtocol {
        PhotoOutcomingMessageCellViewModel(message: message)
    }
    
    func createVocabularyCell(message: Message) -> ChatMessageCellAppearenceProtocol {
        VocabularyOutcomingMessageCellViewModel(message: message)
    }
    
}
