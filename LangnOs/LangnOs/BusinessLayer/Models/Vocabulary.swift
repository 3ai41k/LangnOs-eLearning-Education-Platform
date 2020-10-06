//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Vocabulary: FirebaseDatabaseEntityProtocol {
    let id: String
    let title: String
    let category: String
    let phrasesLearned: Int
    let phrasesLeftToLearn: Int
    let totalLearningTime: Double
    let createdDate: Date
    let words: [Word]
    
    var serialize: [String: Any] {
        [
            "id": id,
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
    
    init(title: String, category: String, words: [Word]) {
        self.id = UUID().uuidString
        self.title = title
        self.category = category
        self.phrasesLearned = 0
        self.phrasesLeftToLearn = 0
        self.totalLearningTime = 0.0
        self.createdDate = Date()
        self.words = words
    }
    
}
