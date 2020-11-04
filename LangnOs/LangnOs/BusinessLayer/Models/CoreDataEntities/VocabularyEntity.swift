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
