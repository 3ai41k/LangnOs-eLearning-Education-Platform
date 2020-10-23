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
}

typealias TitleSectionViewModelProtocol =
    SectionViewViewModelProtocol &
    TitleSectionViewModelInput

final class TitleSectionViewModel: TitleSectionViewModelProtocol {
    
    let text: String
    let font: UIFont
    
    init(text: String) {
        self.text = text
        self.font = .boldSystemFont(ofSize: 21.0)
    }
    
}
