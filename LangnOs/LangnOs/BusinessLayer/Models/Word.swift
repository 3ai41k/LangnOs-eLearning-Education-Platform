//
//  Word.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Word: Codable {
    
    // MARK: - Public properties
    
    let id: String
    var term: String
    var definition: String
    var photoURL: URL?
    
    static var empty: Word {
        Word(term: "", definition: "")
    }
    
    // MARK: - Init
    
    init(term: String, definition: String) {
        self.id = UUID().uuidString
        self.term = term
        self.definition = definition
        self.photoURL = nil
    }
    
    init(entity: WordEntity) {
        self.id = entity.id!.uuidString
        self.term = entity.term!
        self.definition = entity.definition!
        self.photoURL = entity.photoURL
    }
    
}

// MARK: - Equatable

extension Word: Equatable {
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
    
}
