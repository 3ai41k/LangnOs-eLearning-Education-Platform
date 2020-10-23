//
//  FlashCardsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol FlashCardsViewModelInputProtocol {
    
}

protocol FlashCardsViewModelOutputProtocol {
    func closeAction()
}

typealias FlashCardsViewModelProtocol =
    UniversalTableViewModelProtocol &
    FlashCardsViewModelInputProtocol &
    FlashCardsViewModelOutputProtocol

final class FlashCardsViewModel: UniversalTableViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [SectionViewModelProtocol]
    
    // MARK: - Private properties
    
    private let router: FlashCardsCoordinatorProtocol
    private let words: [Word]
    private let speechSynthesizer: SpeakableProtocol
    
    // MARK: - Init
    
    init(router: FlashCardsCoordinatorProtocol, words: [Word], speechSynthesizer: SpeakableProtocol) {
        self.router = router
        self.words = words
        self.speechSynthesizer = speechSynthesizer
        
        self.tableSections = []
        
        setupFlashCardsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupFlashCardsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cells: [CellViewModelProtocol] = words.map({
            FlashCardTableViewCellViewModel(word: $0, speechSynthesizer: speechSynthesizer) { [weak self] error in
                self?.showError(error)
            }
        })
        tableSections.append(TableSectionViewModel(cells: cells))
    }
    
    // MARK: - Actions
    
    private func showError(_ error: Error) {
        router.showAlert(title: "Error!",
                         message: error.localizedDescription,
                         actions: [OkAlertAction(handler: { })])
    }
    
}

// MARK: - FlashCardsViewModelInputProtocol

extension FlashCardsViewModel: FlashCardsViewModelInputProtocol {
    
}

// MARK: - FlashCardsViewModelOutputProtocol

extension FlashCardsViewModel: FlashCardsViewModelOutputProtocol {
    
    func closeAction() {
        router.close()
    }
    
}
