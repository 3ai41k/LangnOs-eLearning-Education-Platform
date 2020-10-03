//
//  VocabularyCollectionViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyCollectionViewCellInputProtocol {
    var title: String { get }
    var numberOfWords: String { get }
}

final class VocabularyCollectionViewCellViewModel: CellViewModelProtocol {
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
    }
    
}

// MARK: - VocabularyCollectionViewCellInputProtocol

extension VocabularyCollectionViewCellViewModel: VocabularyCollectionViewCellInputProtocol {
    
    var title: String {
        vocabulary.title
    }
    
    var numberOfWords: String {
        String(format: "%d %@", vocabulary.words.count, "new words".localize)
    }
    
}
