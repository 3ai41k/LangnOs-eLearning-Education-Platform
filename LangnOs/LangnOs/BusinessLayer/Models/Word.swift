//
//  Word.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Word: FirebaseDatabaseEntityProtocol {
    let term: String
    let definition: String
    
    init(dictionary: [String : Any]) {
        self.term = dictionary["term"] as! String
        self.definition = dictionary["definition"] as! String
    }
}
