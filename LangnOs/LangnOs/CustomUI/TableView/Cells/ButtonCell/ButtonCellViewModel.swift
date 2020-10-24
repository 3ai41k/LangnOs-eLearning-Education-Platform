//
//  ButtonCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ButtonCellViewModelInputProtocol {
    var title: String { get }
    var titleColor: UIColor { get }
}

protocol ButtonCellViewModelOutputProtocol {
    func buttonAction()
}

typealias ButtonCellViewModelProtocol =
    CellViewModelProtocol &
    ButtonCellViewModelInputProtocol &
    ButtonCellViewModelOutputProtocol

final class ButtonCellViewModel: ButtonCellViewModelProtocol {
    
    var title: String
    var titleColor: UIColor
    var buttonHandler: () -> Void
    
    init(title: String, titleColor: UIColor, buttonHandler: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.buttonHandler = buttonHandler
    }
    
    func buttonAction() {
        buttonHandler()
    }
    
}
