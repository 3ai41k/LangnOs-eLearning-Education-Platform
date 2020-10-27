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

// MARK: - DocumentDeletingRequestProtocol

extension VocabularyDeleteRequest: DocumentDeletingRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var entity: Vocabulary {
        vocabulary
    }
    
    var path: String {
        "Vocabularies"
    }
    
    func prepareReference(_ dataBase: Firestore) -> DocumentReference {
        dataBase.collection(path).document(vocabulary.id)
    }
    
}
