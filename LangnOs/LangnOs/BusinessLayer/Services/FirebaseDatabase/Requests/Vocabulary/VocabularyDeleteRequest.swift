//
//  VocabularyDeleteRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct VocabularyDeleteRequest: FirebaseDatabaseRequestProtocol {
    
    let vocabulary: Vocabulary
    
    var collectionName: String {
        "Vocabulary"
    }
    
    var childId: String? {
        vocabulary.id
    }
    
}
