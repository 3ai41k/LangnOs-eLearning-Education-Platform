//
//  FlashCardTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol FlashCardTableViewCellInputProtocol {
    
}

final class FlashCardTableViewCellViewModel: CellViewModelProtocol {
    
    // MARK: - Private properties
    
    private let word: Word
    
    // MARK: - Init
    
    init(word: Word) {
        self.word = word
    }
    
}

// MARK: - FlashCardTableViewCellInputProtocol

extension FlashCardTableViewCellViewModel: FlashCardTableViewCellInputProtocol {
    
}
