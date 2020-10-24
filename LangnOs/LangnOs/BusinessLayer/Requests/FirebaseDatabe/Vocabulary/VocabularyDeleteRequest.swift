//
//  VocabularyDeleteRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseDatabase

struct VocabularyDeleteRequest {
    
    // MARK: - Public properties
    
    let vocabulary: Vocabulary
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyDeleteRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var entity: Vocabulary? {
        vocabulary
    }
    
    func setCollectionPath(_ reference: DatabaseReference) -> DatabaseReference {
        reference.child("Vocabulary").child(vocabulary.id)
    }
    
}
