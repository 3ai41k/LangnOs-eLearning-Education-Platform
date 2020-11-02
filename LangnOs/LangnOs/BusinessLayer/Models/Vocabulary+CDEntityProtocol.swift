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
    
    static func insert(context: NSManagedObjectContext, entity: Vocabulary, mode: DataBaseMode) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if vocabularies.isEmpty {
                entity.isSynchronized = mode.isNeedToSynchronize
                _ = VocabularyEntity(vocabulary: entity, context: context)
            }
        } catch {
            throw error
        }
    }
    
    static func update(context: NSManagedObjectContext, entity: Vocabulary, mode: DataBaseMode) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if let vocabulary = vocabularies.first {
                vocabulary.id = UUID(uuidString: entity.id)
                vocabulary.userId = entity.userId
                vocabulary.isSynchronized = mode.isNeedToSynchronize
                vocabulary.title = entity.title
                vocabulary.category = entity.category
                vocabulary.isFavorite = entity.isFavorite
                vocabulary.isPrivate = entity.isPrivate
                vocabulary.phrasesLearned = Int32(entity.phrasesLearned)
                vocabulary.phrasesLeftToLearn = Int32(entity.phrasesLeftToLearn)
                vocabulary.totalLearningTime = entity.totalLearningTime
                vocabulary.createdDate = entity.createdDate
                vocabulary.words = NSSet(array: entity.words.map({
                    WordEntity(word: $0, context: context)
                }))
            }
        } catch {
            throw error
        }
    }
    
    static func delete(context: NSManagedObjectContext, entity: Vocabulary, mode: DataBaseMode) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            try context.fetch(request).forEach({ context.delete($0) })
        } catch {
            throw error
        }
    }
    
}
