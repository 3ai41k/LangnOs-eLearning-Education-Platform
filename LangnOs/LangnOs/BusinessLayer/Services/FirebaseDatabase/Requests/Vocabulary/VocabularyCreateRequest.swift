//
//  VocabularyCreateRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseDatabase

struct VocabularyCreateRequest {
    
    // MARK: - Public properties
    
    let vocabulary: Vocabulary
    
    var data: [String: Any]? {
        vocabulary.serialize
    }
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyCreateRequest: FirebaseDatabaseRequestProtocol {
    
    private var collectionPath: String {
        "Vocabulary"
    }
    
    func setCollectionPath(_ reference: DatabaseReference) -> DatabaseReference {
        reference.child(collectionPath).child(vocabulary.id)
    }
    
}
