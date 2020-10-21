//
//  VocabularyFilter.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 21.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

enum VocabularyFilter: CaseIterable {
    case name
    case category
    case createdDate
    
    var title: String {
        switch self {
        case .name:
            return "Name".localize
        case .category:
            return "Category".localize
        case .createdDate:
            return "Created date".localize
        }
    }
    
}
