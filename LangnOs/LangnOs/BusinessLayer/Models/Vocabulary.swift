//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class Vocabulary: Codable {
    let id: String
    let userId: String
    let title: String
    let category: String
    var isFavorite: Bool
    var isPrivate: Bool
    let phrasesLearned: Int
    let phrasesLeftToLearn: Int
    let totalLearningTime: Double
    let createdDate: Date
    var words: [Word]
    
    init(userId: String, title: String, category: String, words: [Word]) {
        self.id = UUID().uuidString
        self.userId = userId
        self.title = title
        self.category = category
        self.isFavorite = false
        self.isPrivate = false
        self.phrasesLearned = 0
        self.phrasesLeftToLearn = 0
        self.totalLearningTime = 0.0
        self.createdDate = Date()
        self.words = words
    }
    
    init(entity: VocabularyEntity) {
        self.id = entity.id!.uuidString
        self.userId = entity.userId!
        self.title = entity.title!
        self.category = entity.category!
        self.isFavorite = entity.isFavorite
        self.isPrivate = entity.isPrivate
        self.phrasesLearned = Int(entity.phrasesLearned)
        self.phrasesLeftToLearn = Int(entity.phrasesLeftToLearn)
        self.totalLearningTime = entity.totalLearningTime
        self.createdDate = entity.createdDate!
        self.words = (entity.words?.allObjects as? [WordEntity])!.map({
            Word(entity: $0)
        })
    }
    
}

// MARK: - CDEntityProtocol

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
    
    static func insert(context: NSManagedObjectContext, entity: Vocabulary) throws {
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
    
    static func update(context: NSManagedObjectContext, entity: Vocabulary) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            let vocabularies = try context.fetch(request)
            if let vocabulary = vocabularies.first {
                vocabulary.id = UUID(uuidString: entity.id)
                vocabulary.userId = entity.userId
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
    
    static func delete(context: NSManagedObjectContext, entity: Vocabulary) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        request.predicate = NSPredicate(format: "id == %@", UUID(uuidString: entity.id)! as CVarArg)
        do {
            try context.fetch(request).forEach({ context.delete($0) })
        } catch {
            throw error
        }
    }
    
}

// MARK: - Equatable

extension Vocabulary: Equatable {
    
    static func == (lhs: Vocabulary, rhs: Vocabulary) -> Bool {
        lhs.id == rhs.id
    }
    
}

// MARK: - EmptyableProtocol

extension Vocabulary: EmptyableProtocol {
    
    var isEmpty: Bool {
        title.isEmpty && category.isEmpty && areWordsEmpty
    }
    
    private var areWordsEmpty: Bool {
        for word in words {
            if word.isEmpty {
                return true
            }
        }
        return false
    }
    
}

