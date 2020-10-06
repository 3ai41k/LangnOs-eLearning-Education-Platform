//
//  VocabularyCreateRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct VocabularyCreateRequest: FirebaseDatabaseRequestProtocol {
    
    let vocabulary: Vocabulary
    
    var collectionName: String {
        "Vocabulary"
    }
    
    var childId: String? {
        vocabulary.id
    }
    
    var data: [String: Any]? {
        vocabulary.serialize
    }
    
}