//
//  VocabularyDeleteRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

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
    
    var path: String {
        "Vocabularies"
    }
    
}
