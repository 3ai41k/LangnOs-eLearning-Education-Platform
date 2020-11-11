//
//  SearchVocabularyRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 31.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

enum SearchVocabularBy: String, CaseIterable {
    
    case name = "title"
    case category = "category"
    
    var title: String {
        switch self {
        case .name:
            return "Name".localize
        case .category:
            return "Category".localize
        }
    }
}

struct SearchVocabularyRequest {
    
    // MARK: - Public properties
    
    var searchText: String
    var searchBy: SearchVocabularBy
    
}

// MARK: - DataProviderRequestProtocol

extension SearchVocabularyRequest: DataProviderRequestProtocol {
    
    var collectionPath: CollectionPath {
        .vocabularies
    }
    
}
