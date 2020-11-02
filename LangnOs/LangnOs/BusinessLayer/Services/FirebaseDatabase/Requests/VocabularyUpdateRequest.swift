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
    
    var entity: Vocabulary? {
        vocabulary
    }
    
    var collectionPath: CollectionPath {
        .vocabularies
    }
    
    var documentPath: String? {
        vocabulary.id
    }
    
}
