//
//  IncomingMessageCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class IncomingMessageCellViewModel: ChatMessageCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var content: String {
        message.content
    }
    
    var textAlignment: NSTextAlignment {
        .left
    }
    
    // MARK: - Private properties
    
    private let message: Message
    
    // MARK: - Init
    
    init(message: Message) {
        self.message = message
    }
    
}
