//
//  Message.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    // MARK: - Public properties
    
    let id: String
    let userId: String
    let createdDate: Date
    let content: String
    let photoURL: URL?
    let vocabularyId: String?
    
    // MARK: - Init
    
    init(userId: String, content: String) {
        self.init(userId: userId, content: content, photoURL: nil, vocabularyId: nil)
    }
    
    init(userId: String, content: String, photoURL: URL) {
        self.init(userId: userId, content: content, photoURL: photoURL, vocabularyId: nil)
    }
    
    init(userId: String, vocabulary: Vocabulary) {
        self.init(userId: userId,
                  content: String(format: "Title: %@\nWords: %d", vocabulary.title, vocabulary.words.count),
                  photoURL: nil,
                  vocabularyId: vocabulary.id)
    }
    
    private init(userId: String, content: String, photoURL: URL?, vocabularyId: String?) {
        self.id = UUID().uuidString
        self.userId = userId
        self.createdDate = Date()
        self.content = content
        self.photoURL = photoURL
        self.vocabularyId = vocabularyId
    }
    
}
