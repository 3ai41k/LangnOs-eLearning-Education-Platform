//
//  FlashCardTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol FlashCardTableViewCellInputProtocol {
    var term: String { get }
    var definition: String { get }
}

protocol FlashCardTableViewCellOutputProtocol {
    func speak(text: String)
}

protocol FlashCardTableViewCellBindingProtocol {
    var isPronounceButtonEnabled: ((Bool) -> Void)? { get set }
}

final class FlashCardTableViewCellViewModel: CellViewModelProtocol, FlashCardTableViewCellBindingProtocol {
    
    // MARK: - Public properties
    
    var isPronounceButtonEnabled: ((Bool) -> Void)?
    
    // MARK: - Private properties
    
    private let word: Word
    private let speechSynthesizer: SpeakableProtocol
    private let onErrorHandler: (Error) -> Void
    
    // MARK: - Init
    
    init(word: Word,
         speechSynthesizer: SpeakableProtocol,
         onErrorHandler: @escaping (Error) -> Void) {
        self.word = word
        self.speechSynthesizer = speechSynthesizer
        self.onErrorHandler = onErrorHandler
    }
    
}

// MARK: - FlashCardTableViewCellInputProtocol

extension FlashCardTableViewCellViewModel: FlashCardTableViewCellInputProtocol {
    
    var term: String {
        word.term
    }
    
    var definition: String {
        word.definition
    }
    
}

// MARK: - FlashCardTableViewCellOutputProtocol

extension FlashCardTableViewCellViewModel: FlashCardTableViewCellOutputProtocol {
    
    func speak(text: String) {
        speechSynthesizer.didStartHandler = { [weak self] in
            self?.isPronounceButtonEnabled?(false)
        }
        speechSynthesizer.didFinishHandler = { [weak self] in
            self?.isPronounceButtonEnabled?(true)
        }
        do {
            try speechSynthesizer.speak(string: text)
        } catch {
            onErrorHandler(error)
        }
    }
    
}
