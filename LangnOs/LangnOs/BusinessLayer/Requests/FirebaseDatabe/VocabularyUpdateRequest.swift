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

extension VocabularyUpdateRequest: DocumentUpdatingRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var entity: Vocabulary {
        vocabulary
    }
    
    var path: String {
        "Vocabularies"
    }
    
    var documentData: [String : Any] {
        try! DictionaryEncoder().encode(entity: vocabulary)
    }
    
    func prepareReference(_ dataBase: Firestore) -> DocumentReference {
        dataBase.collection(path).document(vocabulary.id)
    }
    
}
