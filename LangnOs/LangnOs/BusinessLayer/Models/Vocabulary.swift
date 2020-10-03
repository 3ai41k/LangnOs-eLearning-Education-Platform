//
//  Vocabulary.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Vocabulary: FirebaseDatabaseEntityProtocol {
    let title: String
    let words: [Word]
    
    init(dictionary: [String : Any]) {
        self.title = dictionary["title"] as! String
        self.words = (dictionary["words"] as! [[String: Any]]).map({
            Word(dictionary: $0)
        })
    }
}
