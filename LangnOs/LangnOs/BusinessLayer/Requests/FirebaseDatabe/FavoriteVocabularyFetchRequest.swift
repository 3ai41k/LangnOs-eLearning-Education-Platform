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

// MARK: - DataProviderRequestProtocol

extension FavoriteVocabularyFetchRequest: DataProviderRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var collectionPath: CollectionPath {
        .vocabularies
    }
    
    var query: QueryBulderPrototcol? {
        QueryBulder(connectors: [
            QueryAndConnector(componets: [
                IsEqualToComponent("userId", isEqualTo: userId),
                IsEqualToComponent("isFavorite", isEqualTo: true)
            ])
        ])
    }
    
}
