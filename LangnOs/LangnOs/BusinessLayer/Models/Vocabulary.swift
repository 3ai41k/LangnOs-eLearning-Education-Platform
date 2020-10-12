//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

struct Vocabulary {
    let id: String
    let userId: String
    let title: String
    let category: String
    let phrasesLearned: Int
    let phrasesLeftToLearn: Int
    let totalLearningTime: Double
    let createdDate: Date
    let words: [Word]
    
    init(userId: String, title: String, category: String, words: [Word]) {
        self.id = UUID().uuidString
        self.userId = userId
        self.title = title
        self.category = category
        self.phrasesLearned = 0
        self.phrasesLeftToLearn = 0
        self.totalLearningTime = 0.0
        self.createdDate = Date()
        self.words = words
    }
    
}

// MARK: - FDEntityProtocol

extension Vocabulary: FDEntityProtocol {
    
    var serialize: [String: Any] {
        [
            "id": id,
            "userId": userId,
            "title": title,
            "category": category,
            "phrasesLearned": phrasesLearned,
            "phrasesLeftToLearn": phrasesLeftToLearn,
            "totalLearningTime": totalLearningTime,
            "createdDate": createdDate.timeIntervalSince1970,
            "words": words.map({ $0.serialize })
        ]
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.userId = dictionary["userId"] as! String
        self.title = dictionary["title"] as! String
        self.category = dictionary["category"] as! String
        self.phrasesLearned = dictionary["phrasesLearned"] as! Int
        self.phrasesLeftToLearn = dictionary["phrasesLeftToLearn"] as! Int
        self.totalLearningTime = dictionary["totalLearningTime"] as! Double
        self.createdDate = Date(timeIntervalSince1970: TimeInterval(dictionary["createdDate"] as! Double))
        self.words = (dictionary["words"] as! [[String: Any]]).map({
            Word(dictionary: $0)
        })
    }
    
}

// MARK: - CDEntityProtocol

extension Vocabulary: CDEntityProtocol {
    
    init(entity: VocabularyEntity) {
        self.id = entity.id!.uuidString
        self.userId = entity.userId!
        self.title = entity.title!
        self.category = entity.category!
        self.phrasesLearned = Int(entity.phrasesLearned)
        self.phrasesLeftToLearn = Int(entity.phrasesLeftToLearn)
        self.totalLearningTime = entity.totalLearningTime
        self.createdDate = entity.createdDate!
        self.words = (entity.words?.allObjects as? [WordEntity])!.map({
            Word(entity: $0)
        })
    }
    
    static func select(conetxt: NSManagedObjectContext) throws -> [Vocabulary] {
        let request = NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
        do {
            return try conetxt.fetch(request).map({
                Vocabulary(entity: $0)
            })
        } catch {
            throw error
        }
    }
    
    static func insert(conetxt: NSManagedObjectContext, entity: Vocabulary) {
        let vocabulary = VocabularyEntity(context: conetxt)
        vocabulary.id = UUID(uuidString: entity.id)
        vocabulary.userId = entity.userId
        vocabulary.title = entity.title
        vocabulary.category = entity.category
        vocabulary.phrasesLearned = Int32(entity.phrasesLearned)
        vocabulary.phrasesLeftToLearn = Int32(entity.phrasesLeftToLearn)
        vocabulary.totalLearningTime = entity.totalLearningTime
        vocabulary.createdDate = entity.createdDate
        entity.words.forEach({
            let word = WordEntity(context: conetxt)
            word.term = $0.term
            word.definition = $0.definition
            vocabulary.addToWords(word)
        })
    }
    
    static func update(conetxt: NSManagedObjectContext, entity: Vocabulary) {
        
    }
    
    static func delete(conetxt: NSManagedObjectContext, entity: Vocabulary) {
        
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

