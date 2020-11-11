//
//  VocabularyUpdateRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 25.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct VocabularyUpdateRequest {
    
    // MARK: - Public properties
    
    let vocabulary: Vocabulary
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyUpdateRequest: DataProviderRequestProtocol {
    
    var collectionPath: CollectionPath {
        .vocabularies
    }
    
    var documentPath: String? {
        vocabulary.id
    }
    
    var documentData: [String : Any]? {
        try? DictionaryEncoder().encode(entity: vocabulary)
    }
    
}
