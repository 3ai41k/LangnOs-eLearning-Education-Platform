//
//  FavoriteVocabularyCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol FavoriteVocabularyCellViewModelInputProtocol {
    var title: String { get }
    var category: String { get }
}

typealias FavoriteVocabularyCellViewModelProtocol =
    CellViewModelProtocol &
    FavoriteVocabularyCellViewModelInputProtocol

final class FavoriteVocabularyCellViewModel: FavoriteVocabularyCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        vocabulary.title
    }
    
    var category: String {
        vocabulary.category
    }
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
    }
    
}
