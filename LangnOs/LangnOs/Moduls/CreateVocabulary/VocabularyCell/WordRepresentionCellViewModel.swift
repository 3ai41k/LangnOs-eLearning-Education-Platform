//
//  WordRepresentionCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 25.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class WordRepresentionCellViewModel: VocabularyCellViewModel {
    
    // MARK: - Public properties
    
    override var headerValue: String? {
        word.term
    }
    
    override var footerValue: String? {
        word.definition
    }
    
    var word: Word
    
    // MARK: - Init
    
    init(word: Word) {
        self.word = word
        
        super.init(headerTitle: "Term".localize, footerTitle: "Definition".localize)
        
        self.isEditable.value = false
    }
    
    // MARK: - Public methods
    
    override func setHeaderValue(_ text: String) {
        word = Word(term: text, definition: word.definition)
    }
    
    override func setFooterValue(_ text: String) {
        word = Word(term: word.term, definition: text)
    }
    
}
