//
//  WordTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol WordTableViewCellInputProtocol {
    var term: String { get }
    var definition: String { get }
}

final class WordTableViewCellViewModel: CellViewModelProtocol {
    
    // MARK: - Private properties
    
    private let word: Word
    
    // MARK: - Init
    
    init(word: Word) {
        self.word = word
    }
    
}

// MARK: - WordTableViewCellInputProtocol

extension WordTableViewCellViewModel: WordTableViewCellInputProtocol {
    
    var term: String {
        word.term
    }
    
    var definition: String {
        word.definition
    }
    
}
