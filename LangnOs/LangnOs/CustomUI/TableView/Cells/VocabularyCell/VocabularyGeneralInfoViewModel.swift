//
//  VocabularyGeneralInfoViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct VocabularyGeneralInfo: EmptyableProtocol {
    let name: String
    let category: String
    
    var isEmpty: Bool {
        name.isEmpty && category.isEmpty
    }
    
    static var empty: VocabularyGeneralInfo {
        VocabularyGeneralInfo(name: "", category: "")
    }
}

final class VocabularyGeneralInfoViewModel: VocabularyCellViewModel {
    
    // MARK: - Public properties
    
    override var headerValue: String? {
        vocabularyGeneralInfo.name
    }
    
    override var footerValue: String? {
        vocabularyGeneralInfo.category
    }
    
    var vocabularyGeneralInfo: VocabularyGeneralInfo
    
    // MARK: - Init
    
    init() {
        self.vocabularyGeneralInfo = .empty
        
        super.init(headerTitle: "Name".localize, footerTitle: "Category".localize)
    }
    
    // MARK: - Public methods
    
    override func setHeaderValue(_ text: String) {
        vocabularyGeneralInfo = VocabularyGeneralInfo(name: text, category: vocabularyGeneralInfo.category)
    }
    
    override func setFooterValue(_ text: String) {
        vocabularyGeneralInfo = VocabularyGeneralInfo(name: vocabularyGeneralInfo.name, category: text)
    }
    
    
}
