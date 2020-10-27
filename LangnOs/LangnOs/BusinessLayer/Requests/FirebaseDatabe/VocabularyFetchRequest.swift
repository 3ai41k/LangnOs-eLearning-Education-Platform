//
//  VocabularyFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct VocabularyFetchRequest {
    
    // MARK: - Public properties
    
    var userId: String
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyFetchRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var path: String {
        "Vocabularies"
    }
    
    func setQuere(_ reference: CollectionReference) -> Query {
        reference.whereField("userId", isEqualTo: userId)
    }
    
}
