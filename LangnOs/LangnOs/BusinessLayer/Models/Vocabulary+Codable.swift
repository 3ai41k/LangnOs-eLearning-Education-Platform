//
//  Vocabulary+Codable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

extension Vocabulary: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case category
        case isFavorite
        case isPrivate
        case phrasesLearned
        case phrasesLeftToLearn
        case totalLearningTime
        case createdDate
        case words
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(phrasesLearned, forKey: .phrasesLearned)
        try container.encode(phrasesLeftToLearn, forKey: .phrasesLeftToLearn)
        try container.encode(totalLearningTime, forKey: .totalLearningTime)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(words, forKey: .words)
    }
    
}
