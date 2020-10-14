//
//  Word.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

struct Word {
    let term: String
    let definition: String
    
    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
    }
    
}

// MARK: - FDEntityProtocol

extension Word: FDEntityProtocol {
    
    init(dictionary: [String: Any]) {
        self.term = dictionary["term"] as! String
        self.definition = dictionary["definition"] as! String
    }
    
    var serialize: [String: Any] {
        [
            "term": term,
            "definition": definition
        ]
    }
    
}

// MARK: - CDEntityProtocol

extension Word: CDEntityProtocol {
    
    init(entity: WordEntity) {
        self.term = entity.term!
        self.definition = entity.definition!
    }
    
    static func select(context: NSManagedObjectContext) throws -> [Word] {
        []
    }
    
    func insert(context: NSManagedObjectContext) {
        
    }
    
    func delete(context: NSManagedObjectContext) throws {
        
    }
    
}

// MARK: - EmptyableProtocol

extension Word: EmptyableProtocol {
    
    var isEmpty: Bool {
        term.isEmpty && definition.isEmpty
    }
    
}
