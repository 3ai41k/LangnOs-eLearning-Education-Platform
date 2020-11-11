//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Vocabulary: Codable {
    
    // MARK: - Public properties
    
    let id: String
    let userId: String
    let title: String
    let category: String
    var isFavorite: Bool {
        didSet {
            modifiedDate = Date()
        }
    }
    var isPrivate: Bool {
        didSet {
            modifiedDate = Date()
        }
    }
    let phrasesLearned: Int
    let phrasesLeftToLearn: Int
    let totalLearningTime: Double
    let createdDate: Date
    var modifiedDate: Date
    var words: [Word] {
        didSet {
            modifiedDate = Date()
        }
    }
    
    // MARK: - Init
    
    init(userId: String, title: String, category: String, isPrivate: Bool, words: [Word]) {
        self.id = UUID().uuidString
        self.userId = userId
        self.title = title
        self.category = category
        self.isFavorite = false
        self.isPrivate = isPrivate
        self.phrasesLearned = 0
        self.phrasesLeftToLearn = 0
        self.totalLearningTime = 0.0
        self.createdDate = Date()
        self.modifiedDate = Date()
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
        self.modifiedDate = entity.modifiedDate!
        self.words = (entity.words?.allObjects as? [WordEntity])!.map({
            Word(entity: $0)
        })
    }
    
}

// MARK: - Equatable

extension Vocabulary: Equatable {
    
    static func == (lhs: Vocabulary, rhs: Vocabulary) -> Bool {
        lhs.id == rhs.id
    }
    
}

