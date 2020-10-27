//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

struct Vocabulary: Codable {
    let id: String
    let userId: String
    let title: String
    let category: String
    var isFavorite: Bool
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
        self.phrasesLearned = Int(entity.phrasesLearned)
        self.phrasesLeftToLearn = Int(entity.phrasesLeftToLearn)
        self.totalLearningTime = entity.totalLearningTime
        self.createdDate = entity.createdDate!
        self.words = (entity.words?.allObjects as? [WordEntity])!.map({
            Word(entity: $0)
        })
    }
    
    init(update: Vocabulary, words: [Word]) {
        self.id = update.id
        self.userId = update.userId
        self.title = update.title
        self.category = update.category
        self.isFavorite = update.isFavorite
        self.phrasesLearned = update.phrasesLearned
        self.phrasesLeftToLearn = update.phrasesLeftToLearn
        self.totalLearningTime = update.totalLearningTime
        self.createdDate = update.createdDate
        self.words = words
    }
    
}

// MARK: - CDEntityProtocol

extension Vocabulary: CDEntityProtocol {
    
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [Vocabulary] {
        try VocabularyFetcher().select(context: context, predicate: predicate)
    }
    
    static func insert(context: NSManagedObjectContext, entity: Vocabulary) throws {
        try VocabularyFetcher().insert(context: context, entity: entity)
    }
    
    static func update(context: NSManagedObjectContext, entity: Vocabulary) throws {
        try VocabularyFetcher().update(context: context, entity: entity)
    }
    
    static func delete(context: NSManagedObjectContext, entity: Vocabulary) throws {
        try VocabularyFetcher().delete(context: context, entity: entity)
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

