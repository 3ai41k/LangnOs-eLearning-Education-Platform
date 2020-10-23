//
//  VocabularyCollectionViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyCollectionViewCellInputProtocol {
    var title: String { get }
    var category: String { get }
    var phrasesLearned: String { get }
    var phrasesLeftToLearn: String { get }
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
    
    var category: String {
        vocabulary.category
    }
    
    var phrasesLearned: String {
        String(vocabulary.phrasesLearned)
    }
    
    var phrasesLeftToLearn: String {
        String(vocabulary.phrasesLeftToLearn)
    }
    
}
