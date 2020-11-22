//
//  ChatMessageAbstractFactoryProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 22.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol ChatMessageAbstractFactoryProtocol {
    func createTextCell(message: Message) -> ChatMessageCellAppearenceProtocol
    func createPhotoCell(message: Message) -> ChatMessageCellAppearenceProtocol
    func createVocabularyCell(message: Message) -> ChatMessageCellAppearenceProtocol
}
