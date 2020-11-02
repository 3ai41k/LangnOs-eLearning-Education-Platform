//
//  VocabularyCreateRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct VocabularyCreateRequest {
    
    // MARK: - Public properties
    
    let vocabulary: Vocabulary
    
}

// MARK: - DataProviderRequestProtocol

extension VocabularyCreateRequest: DataProviderRequestProtocol {
    
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
