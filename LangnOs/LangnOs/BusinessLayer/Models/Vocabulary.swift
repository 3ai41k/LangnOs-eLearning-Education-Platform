//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class Vocabulary {
    
    // MARK: - Public properties
    
    let id: String
    let userId: String
    private(set) var isSynchronized: Bool
    let title: String
    let category: String
    var isFavorite: Bool
    var isPrivate: Bool
    let phrasesLearned: Int
    let phrasesLeftToLearn: Int
    let totalLearningTime: Double
    let createdDate: Date
    var words: [Word]
    
    // MARK: - Init
    
    init(userId: String, title: String, category: String, words: [Word]) {
        self.id = UUID().uuidString
        self.userId = userId
        self.isSynchronized = false
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        isSynchronized = false
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(String.self, forKey: .category)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        phrasesLearned = try container.decode(Int.self, forKey: .phrasesLearned)
        phrasesLeftToLearn = try container.decode(Int.self, forKey: .phrasesLeftToLearn)
        totalLearningTime = try container.decode(Double.self, forKey: .totalLearningTime)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        words = try container.decode([Word].self, forKey: .words)
    }
    
    init(entity: VocabularyEntity) {
        self.id = entity.id!.uuidString
        self.userId = entity.userId!
        self.isSynchronized = entity.isSynchronized
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
    
    // MARK: - Public methods
    
    func needSynchronize() {
        isSynchronized = false
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

