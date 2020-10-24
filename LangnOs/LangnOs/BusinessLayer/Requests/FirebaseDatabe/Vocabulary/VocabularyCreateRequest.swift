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
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyCreateRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var entity: Vocabulary? {
        vocabulary
    }
    
    func toDicationary() -> [String : Any]? {
        try? DictionaryEncoder().encode(entity: vocabulary)
    }
    
    func setCollectionPath(_ reference: DatabaseReference) -> DatabaseReference {
        reference.child("Vocabulary").child(vocabulary.id)
    }
    
}
