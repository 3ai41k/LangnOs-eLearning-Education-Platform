//
//  Word.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Word: Codable {
    
    var term: String
    var definition: String
    var photoURL: URL?
    
    static var empty: Word {
        Word(term: "", definition: "")
    }
    
    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
        self.photoURL = nil
    }
    
    init(entity: WordEntity) {
        self.term = entity.term!
        self.definition = entity.definition!
        self.photoURL = entity.photoURL
    }
    
}

// MARK: - Equatable

extension Word: Equatable {
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.term == rhs.term && lhs.definition == rhs.definition
    }
    
}
