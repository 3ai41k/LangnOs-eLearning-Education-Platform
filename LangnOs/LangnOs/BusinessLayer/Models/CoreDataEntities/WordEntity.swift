//
//  WordEntity.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class WordEntity: NSManagedObject {
    
    // MARK: - Init
    
    convenience init(word: Word, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = UUID(uuidString: word.id)
        self.term = word.term
        self.definition = word.definition
        self.photoURL = word.photoURL
    }
    
}
