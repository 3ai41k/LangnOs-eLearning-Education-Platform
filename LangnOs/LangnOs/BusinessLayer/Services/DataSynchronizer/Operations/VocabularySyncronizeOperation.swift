//
//  VocabularySyncronizeOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class VocabularySyncronizeOperation: SyncronizeOperation {
    
    // MARK: - Private properties
    
    private let userId: String
    
    // MARK: - Init
    
    init(userId: String) {
        self.userId = userId
        
        super.init()
    }
    
    // MARK: - Override
    
    override func syncronize() {
        let predicate = NSPredicate(format: "userId == %@ AND isSynchronized == %@", userId, false)
        let entities = try? Vocabulary.select(context: CoreDataStack.shared.viewContext, predicate: predicate)
        entities?.forEach({ (entity) in
            let reqest = VocabularyCreateRequest(vocabulary: entity)
            firebaseDatabase.create(request: reqest, onSuccess: {
                try? Vocabulary.update(context: CoreDataStack.shared.viewContext, entity: entity, mode: .online)
            }) { (error) in
                print("Unresolved error \(error.localizedDescription)")
            }
        })
    }
    
}
