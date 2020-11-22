//
//  Optional+IsNil.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 22.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

extension Optional {
    
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    
    var isNotNil: Bool {
        !isNil
    }
    
}
