//
//  VocabularyFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseDatabase

struct VocabularyFetchRequest {
    
    // MARK: - Public properties
    
    var userId: String
    
}

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyFetchRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = Vocabulary
    
    func setCollectionPath(_ reference: DatabaseReference) -> DatabaseReference {
        reference.child("Vocabulary")
    }
    
    func setQuary(_ reference: DatabaseReference) -> DatabaseQuery? {
        reference.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
    }
    
}
