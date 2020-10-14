//
//  VocabularyFilterFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

import FirebaseDatabase

struct VocabularyFilterFetchRequest { }

// MARK: - FirebaseDatabaseRequestProtocol

extension VocabularyFilterFetchRequest: FirebaseDatabaseRequestProtocol {
    
    typealias Entity = VocabularyFilter
    
    private var collectionPath: String {
        "VocabularyFilter"
    }
    
    func setCollectionPath(_ reference: DatabaseReference) -> DatabaseReference {
        reference.child(collectionPath)
    }
    
}
