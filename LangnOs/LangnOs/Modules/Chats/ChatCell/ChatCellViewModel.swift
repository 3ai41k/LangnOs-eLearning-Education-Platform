//
//  ChatCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol ChatCellViewModelInputProtocol {
    var name: String { get }
    var shortName: String { get }
}

typealias ChatCellViewModelProtocol =
    ChatCellViewModelInputProtocol &
    CellViewModelProtocol

final class ChatCellViewModel: ChatCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var name: String {
        chat.name
    }
    
    var shortName: String {
        guard let firstLetter = chat.name.first else { return "" }
        return String(firstLetter)
    }
    
    // MARK: - Private properties
    
    private let chat: Chat
    
    // MARK: - Init
    
    init(chat: Chat) {
        self.chat = chat
    }
    
}
