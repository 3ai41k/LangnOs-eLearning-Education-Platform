//
//  TitleSectionViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol TitleSectionViewModelInput {
    var text: String { get }
    var font: UIFont { get }
    var buttonText: String? { get }
}

protocol TitleSectionViewModelOutput {
    func selectAction()
}

typealias TitleSectionViewModelProtocol =
    TitleSectionViewModelInput &
    TitleSectionViewModelOutput &
    SectionViewViewModelProtocol

final class TitleSectionViewModel: TitleSectionViewModelProtocol {
    
    let text: String
    let font: UIFont
    let buttonText: String?
    let buttonHandler: (() -> Void)?
    
    init(text: String, buttonText: String? = nil, buttonHandler: (() -> Void)? = nil) {
        self.text = text
        self.font = .boldSystemFont(ofSize: 21.0)
        self.buttonText = buttonText
        self.buttonHandler = buttonHandler
    }
    
    func selectAction() {
        buttonHandler?()
    }
    
}
