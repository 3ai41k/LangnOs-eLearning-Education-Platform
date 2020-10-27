//
//  VocabularyUpdateRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 25.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct VocabularyUpdateRequest {
    
    // MARK: - Public properties
    
    let vocabulary: Vocabulary
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyUpdateRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var entity: Vocabulary? {
        vocabulary
    }
    
    var path: String {
        "Vocabularies"
    }
    
    var dicationary: [String : Any]? {
        try? DictionaryEncoder().encode(entity: vocabulary)
    }
    
}