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
    var buttonTitle: String? { get }
    var isButtonHidden: Bool { get }
}

protocol MessageCellViewModelOutputProtocol {
    func buttonAction()
}

typealias MessageCellViewModelProtocol =
    CellViewModelProtocol &
    MessageCellViewModelInputProtocol &
    MessageCellViewModelOutputProtocol

final class MessageCellViewModel: MessageCellViewModelProtocol {
    
    var message: String
    var buttonTitle: String?
    
    var isButtonHidden: Bool {
        buttonTitle == nil || buttonHandler == nil
    }
    
    var buttonHandler: (() -> Void)?
    
    init(message: String, buttonTitle: String? = nil, buttonHandler: (() -> Void)? = nil) {
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonHandler = buttonHandler
    }
    
    func buttonAction() {
        buttonHandler?()
    }
    
}
