//
//  VocabularyEntity.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class VocabularyEntity: NSManagedObject {
    
    // MARK: - Init
    
    convenience init(vocabulary: Vocabulary, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = UUID(uuidString: vocabulary.id)
        self.userId = vocabulary.userId
        self.isSynchronized = NetworkState.shared.isReachable
        self.title = vocabulary.title
        self.category = vocabulary.category
        self.isFavorite = vocabulary.isFavorite
        self.isPrivate = vocabulary.isPrivate
        self.phrasesLearned = Int32(vocabulary.phrasesLearned)
        self.phrasesLeftToLearn = Int32(vocabulary.phrasesLeftToLearn)
        self.totalLearningTime = vocabulary.totalLearningTime
        self.createdDate = vocabulary.createdDate
        self.words = NSSet(array: vocabulary.words.map({
            WordEntity(word: $0, context: context)
        }))
    }
    
    // MARK: - Public properties
    
    func update(_ vocabulary: Vocabulary, context: NSManagedObjectContext) {
        self.id = UUID(uuidString: vocabulary.id)
        self.userId = vocabulary.userId
        self.isSynchronized = NetworkState.shared.isReachable
        self.title = vocabulary.title
        self.category = vocabulary.category
        self.isFavorite = vocabulary.isFavorite
        self.isPrivate = vocabulary.isPrivate
        self.phrasesLearned = Int32(vocabulary.phrasesLearned)
        self.phrasesLeftToLearn = Int32(vocabulary.phrasesLeftToLearn)
        self.totalLearningTime = vocabulary.totalLearningTime
        self.createdDate = vocabulary.createdDate
        self.words = NSSet(array: vocabulary.words.map({
            WordEntity(word: $0, context: context)
        }))
    }
    
}

// MARK: - CDEntityProtocol

extension VocabularyEntity: CDEntityProtocol {
    
    typealias Entity = Vocabulary
    
    static func selectAllBy(userId: String, context: NSManagedObjectContext) throws -> [Vocabulary] {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        do {
            return try context.fetch(request).map({ Vocabulary(entity: $0) })
        } catch {
            throw error
        }
    }
    
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [Vocabulary] {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = predicate
        do {
            return try context.fetch(request).map({ Vocabulary(entity: $0) })
        } catch {
            throw error
        }
    }
    
    static func insert(entity: Vocabulary, context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if vocabularies.isEmpty {
                _ = VocabularyEntity(vocabulary: entity, context: context)
            }
        } catch {
            throw error
        }
    }
    
    static func update(entity: Vocabulary, context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if let vocabulary = vocabularies.first {
                vocabulary.update(entity, context: context)
            }
        } catch {
            throw error
        }
    }
    
    static func delete(entity: Vocabulary, context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            try context.fetch(request).forEach({ context.delete($0) })
        } catch {
            throw error
        }
    }
    
}
