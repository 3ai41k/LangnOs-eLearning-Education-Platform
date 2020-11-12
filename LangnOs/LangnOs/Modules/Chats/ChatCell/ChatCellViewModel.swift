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
}

typealias ChatCellViewModelProtocol =
    ChatCellViewModelInputProtocol &
    CellViewModelProtocol

final class ChatCellViewModel: ChatCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var name: String {
        user.name
    }
    
    // MARK: - Private properties
    
    private let user: User1
    
    // MARK: - Init
    
    init(user: User1) {
        self.user = user
    }
    
}
