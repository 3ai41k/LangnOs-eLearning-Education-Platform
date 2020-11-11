//
//  TextCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol TextCellViewModelInpotProtocol {
    var text: String { get }
}

typealias TextCellViewModelProtocol =
    TextCellViewModelInpotProtocol &
    CellViewModelProtocol

final class TextCellViewModel: TextCellViewModelProtocol {
    
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
}
