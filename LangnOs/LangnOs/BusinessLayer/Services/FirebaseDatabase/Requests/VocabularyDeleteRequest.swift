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
    
    var collectionPath: String {
        CollectionPath.vocabularies.rawValue
    }
    
    var documentPath: String? {
        vocabulary.id
    }
    
}
