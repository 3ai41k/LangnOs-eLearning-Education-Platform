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
        vocabulary.category
    }
    
    var totalWords: String {
        "Words: ".localize + String(vocabulary.words.count)
    }
    
    var isFavorite: CurrentValueSubject<Bool, Never>
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    private let favoriteHandler: (Bool) -> Void
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary, favoriteHandler: @escaping (Bool) -> Void) {
        self.vocabulary = vocabulary
        self.favoriteHandler = favoriteHandler
        self.isFavorite = .init(vocabulary.isFavorite)
    }
    
    // MARK: - Actions
    
    func favoriteAction() {
        let updateState = isFavorite.value ? false : true
        isFavorite.value = updateState
        favoriteHandler(updateState)
    }
    
}
