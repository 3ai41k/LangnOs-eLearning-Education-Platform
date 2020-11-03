//
//  VocabularySyncronizeOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class VocabularySyncronizeOperation: SyncronizeOperation {
    
    // MARK: - Private properties
    
    private let userId: String
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(userId: String, context: NSManagedObjectContext) {
        self.userId = userId
        self.context = context
        
        super.init()
    }
    
    // MARK: - Override
    
    override func syncronize() {
        let predicate = NSPredicate(format: "userId == %@ AND isSynchronized == %@", argumentArray: [userId, false])
        let entities = try? Vocabulary.select(context: context, predicate: predicate)
        entities?.forEach({ (entity) in
            let reqest = VocabularyCreateRequest(vocabulary: entity)
            firebaseDatabase.create(request: reqest, onSuccess: {
                try? entity.update(context: CoreDataStack.shared.viewContext, mode: .online)
                self.state = .finishsed
            }) { (error) in
                print("Unresolved error \(error.localizedDescription)")
                self.state = .finishsed
            }
        })
    }
    
}
