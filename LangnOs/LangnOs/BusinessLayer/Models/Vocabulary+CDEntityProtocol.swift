//
//  Vocabulary+CDEntityProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

extension Vocabulary: CDEntityProtocol {
    
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [Vocabulary] {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = predicate
        do {
            return try context.fetch(request).map({ Vocabulary(entity: $0) })
        } catch {
            throw error
        }
    }
    
    func insert(context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: self.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if NetworkState.shared.isReachable { self.needSynchronize() }
            if vocabularies.isEmpty {
                _ = VocabularyEntity(vocabulary: self, context: context)
            }
        } catch {
            throw error
        }
    }
    
    func update(context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: self.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if let vocabulary = vocabularies.first {
                vocabulary.id = UUID(uuidString: self.id)
                vocabulary.userId = self.userId
                vocabulary.isSynchronized = NetworkState.shared.isReachable
                vocabulary.title = self.title
                vocabulary.category = self.category
                vocabulary.isFavorite = self.isFavorite
                vocabulary.isPrivate = self.isPrivate
                vocabulary.phrasesLearned = Int32(self.phrasesLearned)
                vocabulary.phrasesLeftToLearn = Int32(self.phrasesLeftToLearn)
                vocabulary.totalLearningTime = self.totalLearningTime
                vocabulary.createdDate = self.createdDate
                vocabulary.words = NSSet(array: self.words.map({
                    WordEntity(word: $0, context: context)
                }))
            }
        } catch {
            throw error
        }
    }
    
    func delete(context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: self.id)! as CVarArg)
        do {
            try context.fetch(request).forEach({ context.delete($0) })
        } catch {
            throw error
        }
    }
    
}
