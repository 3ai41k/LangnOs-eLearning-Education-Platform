//
//  VocabularySynchronizeOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class VocabularySynchronizeOperation: SynchronizeOperation {
    
    // MARK: - Override
    
    override func syncronize() {
        let vocabularies = getUnsynchronizedVocabularies()
        if vocabularies.isEmpty {
            state = .finished
        } else {
            vocabularies.forEach({ (vocabulary) in
                let reqest = VocabularyCreateRequest(vocabulary: vocabulary)
                dispatchGroup.enter()
                self.firebaseDatabase.create(request: reqest, onSuccess: {
                    self.updateVocabulary(vocabulary)
                    self.dispatchGroup.leave()
                }) { (error) in
                    self.handleAnError(error)
                }
            })
        }
    }
    
    // MARK: - Private methods
    
    private func getUnsynchronizedVocabularies() -> [Vocabulary] {
        guard let userId = UserSession.shared.currentUser?.id else { return [] }
        
        let predicate = NSPredicate(format: "userId == %@ AND isSynchronized == %@", argumentArray: [userId, false])
        do {
            return try VocabularyEntity.select(context: CoreDataStack.shared.viewContext, predicate: predicate)
        } catch {
            handleAnError(error)
        }
        return []
    }
    
    private func updateVocabulary(_ vocabulary: Vocabulary) {
        do {
            try VocabularyEntity.update(entity: vocabulary, context: CoreDataStack.shared.viewContext)
        } catch {
            handleAnError(error)
        }
    }
    
    private func handleAnError(_ error: Error) {
        print("Unresolved error \(error.localizedDescription)")
        state = .finished
    }
    
}
