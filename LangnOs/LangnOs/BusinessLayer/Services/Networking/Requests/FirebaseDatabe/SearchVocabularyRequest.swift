//
//  SearchVocabularyRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 31.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

enum SearchVocabularBy: String {
    case name = "title"
    case category = "category"
}

struct SearchVocabularyRequest {
    
    // MARK: - Public properties
    
    var searchText: String
    var searchBy: SearchVocabularBy
    
}

// MARK: - DataProviderRequestProtocol

extension SearchVocabularyRequest: DataProviderRequestProtocol {
    
    typealias Entity = Vocabulary
    
    var collectionPath: CollectionPath {
        .vocabularies
    }
    
    var query: QueryComponentProtocol? {
        SearchComponets(searchBy.rawValue, search: searchText)
    }
    
    
}
