//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Vocabulary: FirebaseDatabaseEntityProtocol {
    let title: String
    let category: String
    let phrasesLearned: Int
    let phrasesLeftToLearn: Int
    let totalLearningTime: Double
    let words: [Word]
    
    init(dictionary: [String : Any]) {
        self.title = dictionary["title"] as! String
        self.category = dictionary["category"] as! String
        self.phrasesLearned = dictionary["phrasesLearned"] as! Int
        self.phrasesLeftToLearn = dictionary["phrasesLeftToLearn"] as! Int
        self.totalLearningTime = dictionary["totalLearningTime"] as! Double
        self.words = (dictionary["words"] as! [[String: Any]]).map({
            Word(dictionary: $0)
        })
    }
}
