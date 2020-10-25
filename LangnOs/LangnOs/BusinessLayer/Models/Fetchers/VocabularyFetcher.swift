//
//  VocabularyFetcher.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class VocabularyFetcher: CDEntityFather<Vocabulary> {
    
    // MARK: - Override
    
    override func select(context: NSManagedObjectContext) throws -> [Vocabulary] {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        do {
            return try context.fetch(request).map({ Vocabulary(entity: $0) })
        } catch {
            throw error
        }
    }
    
    override func insert(context: NSManagedObjectContext, entity: Vocabulary) {
        let vocabulary = VocabularyEntity(context: context)
        vocabulary.id = UUID(uuidString: entity.id)
        vocabulary.userId = entity.userId
        vocabulary.title = entity.title
        vocabulary.category = entity.category
        vocabulary.phrasesLearned = Int32(entity.phrasesLearned)
        vocabulary.phrasesLeftToLearn = Int32(entity.phrasesLeftToLearn)
        vocabulary.totalLearningTime = entity.totalLearningTime
        vocabulary.createdDate = entity.createdDate
        entity.words.forEach({
            let word = WordEntity(context: context)
            word.term = $0.term
            word.definition = $0.definition
            vocabulary.addToWords(word)
        })
    }
    
    override func update(context: NSManagedObjectContext, entity: Vocabulary) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        do {
            let vocabularies = try context.fetch(request)
            if let vocabulary = vocabularies.first {
                vocabulary.id = UUID(uuidString: entity.id)
                vocabulary.userId = entity.userId
                vocabulary.title = entity.title
                vocabulary.category = entity.category
                vocabulary.phrasesLearned = Int32(entity.phrasesLearned)
                vocabulary.phrasesLeftToLearn = Int32(entity.phrasesLeftToLearn)
                vocabulary.totalLearningTime = entity.totalLearningTime
                vocabulary.createdDate = entity.createdDate
                vocabulary.words = NSSet(object: entity.words)
            }
        } catch {
            throw error
        }
    }
    
    override func delete(context: NSManagedObjectContext, entity: Vocabulary) throws {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        do {
            try context.fetch(request).forEach({ context.delete($0) })
        } catch {
            throw error
        }
    }
    
}
