//
//  Word.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

struct Word: Codable {
    
    let term: String
    let definition: String
    
    static var empty: Word {
        Word(term: "", definition: "")
    }
    
    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
    }
    
    init(entity: WordEntity) {
        self.term = entity.term!
        self.definition = entity.definition!
    }
    
}

// MARK: - Equatable

extension Word: Equatable {
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.term == rhs.term && lhs.definition == rhs.definition
    }
    
}

// MARK: - EmptyableProtocol

extension Word: EmptyableProtocol {
    
    var isEmpty: Bool {
        term.isEmpty && definition.isEmpty
    }
    
}
