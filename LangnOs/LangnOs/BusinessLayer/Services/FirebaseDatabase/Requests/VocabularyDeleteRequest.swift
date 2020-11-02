//
//  VocabularyDeleteRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct VocabularyDeleteRequest {
    
    // MARK: - Public properties
    
    let vocabulary: Vocabulary
    
}

// MARK: - DataProviderRequestProtocol

extension VocabularyDeleteRequest: DataProviderRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var collectionPath: CollectionPath {
        .vocabularies
    }
    
    var documentPath: String? {
        vocabulary.id
    }
    
}
