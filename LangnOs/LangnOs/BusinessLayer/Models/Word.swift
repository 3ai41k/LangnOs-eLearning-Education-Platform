//
//  Word.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Word: FirebaseDatabaseEntityProtocol {
    let term: String
    let definition: String
    
    var serialize: [String: Any] {
        [
            "term": term,
            "definition": definition
        ]
    }
    
    init(dictionary: [String: Any]) {
        self.term = dictionary["term"] as! String
        self.definition = dictionary["definition"] as! String
    }
    
    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
    }
    
}

// MARK: - EmptyableProtocol

extension Word: EmptyableProtocol {
    
    var isEmpty: Bool {
        term.isEmpty && definition.isEmpty
    }
    
}
