//
//  CreateWordTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol CreateWordTableViewCellViewModelProtocol: CellViewModelProtocol {
    var word: Word { get }
}

protocol CreateWordTableViewCellInputProtocol {
    var term: String { get }
    var definition: String { get }
}

protocol CreateWordTableViewCellOutputProtocol {
    func setTerm(_ term: String)
    func setDefinition(_ definition: String)
}

final class CreateWordTableViewCellViewModel: CreateWordTableViewCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var word: Word
    
    // MARK: - Init
    
    init() {
        self.word = Word(term: "", definition: "")
    }
    
}

// MARK: - CreateWordTableViewCellInputProtocol

extension CreateWordTableViewCellViewModel: CreateWordTableViewCellInputProtocol {
    
    var term: String {
        word.term
    }
    
    var definition: String {
        word.definition
    }
    
}

// MARK: - CreateWordTableViewCellOutputProtocol

extension CreateWordTableViewCellViewModel: CreateWordTableViewCellOutputProtocol {
    
    func setTerm(_ term: String) {
        self.word = Word(term: term, definition: word.definition)
    }
    
    func setDefinition(_ definition: String) {
        self.word = Word(term: word.term, definition: definition)
    }
    
}

