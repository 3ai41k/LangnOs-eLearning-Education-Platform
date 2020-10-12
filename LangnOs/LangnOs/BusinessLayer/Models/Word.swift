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
    
}

// MARK: - CDEntityProtocol

extension Word: CDEntityProtocol {
    
    init(entity: WordEntity) {
        self.term = entity.term!
        self.definition = entity.definition!
    }
    
    static func select(conetxt: NSManagedObjectContext) throws -> [Word] {
        []
    }
    
    static func insert(conetxt: NSManagedObjectContext, entity: Word) {
        
    }
    
    static func update(conetxt: NSManagedObjectContext, entity: Word) {
        
    }
    
    static func delete(conetxt: NSManagedObjectContext, entity: Word) {
        
    }
    
    
}

// MARK: - EmptyableProtocol

extension Word: EmptyableProtocol {
    
    var isEmpty: Bool {
        term.isEmpty && definition.isEmpty
    }
    
}
