//
//  MessageCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol MessageCellViewModelInputProtocol {
    var message: String { get }
}

typealias MessageCellViewModelProtocol =
    CellViewModelProtocol &
    MessageCellViewModelInputProtocol

final class MessageCellViewModel: MessageCellViewModelProtocol {
    
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
}
