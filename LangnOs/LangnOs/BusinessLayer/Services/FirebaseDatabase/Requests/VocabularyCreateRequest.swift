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
    
    var collectionPath: String {
        CollectionPath.vocabularies.rawValue
    }
    
    var documentPath: String? {
        vocabulary.id
    }
    
    var documentData: [String : Any]? {
        try? DictionaryEncoder().encode(entity: vocabulary)
    }
    
}
