//
//  FirebaseDatabaseVocabularyFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct FirebaseDatabaseVocabularyFetchRequest: FirebaseDatabaseRequestProtocol {
    
    var collectionName: String {
        "Vocabulary"
    }
    
    var data: [String: Any]? {
        nil
    }
    
}