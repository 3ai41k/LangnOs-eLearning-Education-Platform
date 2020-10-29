//
//  AddToFavoriteCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol AddToFavoriteCellViewModelInputProtocol {
    var name: String { get }
    var category: String { get }
    var totalWords: String { get }
    var isFavorite: CurrentValueSubject<Bool, Never> { get }
}

protocol AddToFavoriteCellViewModelOutputProtocol {
    func favoriteAction()
}

typealias AddToFavoriteCellViewModelProtocol =
    AddToFavoriteCellViewModelInputProtocol &
    AddToFavoriteCellViewModelOutputProtocol &
    CellViewModelProtocol

final class AddToFavoriteCellViewModel: AddToFavoriteCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var name: String {
        vocabulary.title
    }
    
    var category: String {
        "Categroy: ".localize + vocabulary.category
    }
    
    var totalWords: String {
        "Total words: ".localize + String(vocabulary.words.count)
    }
    
    var isFavorite: CurrentValueSubject<Bool, Never>
    
    // MARK: - Private properties
    
    private var vocabulary: Vocabulary
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
        self.isFavorite = .init(vocabulary.isFavorite)
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    
    // MARK: - Actions
    
    func favoriteAction() {
        let state = vocabulary.isFavorite ? false : true
        vocabulary.isFavorite = state
        isFavorite.value = state
    }
    
}
