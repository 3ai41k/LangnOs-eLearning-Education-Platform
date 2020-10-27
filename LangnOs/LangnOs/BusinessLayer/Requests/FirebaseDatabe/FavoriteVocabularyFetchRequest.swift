//
//  FavoriteVocabularyFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 27.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct FavoriteVocabularyFetchRequest {
    
    // MARK: - Public properties
    
    var userId: String
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension FavoriteVocabularyFetchRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var path: String {
        "Vocabularies"
    }
    
    func setQuere(_ reference: CollectionReference) -> Query {
        reference
            .whereField("userId", isEqualTo: userId)
            .whereField("isFavorite", isEqualTo: true)
    }
    
}
