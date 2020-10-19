//
//  WritingViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 18.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

enum WritingViewModelError: Error {
    case wordsAreLearned
}

protocol WritingViewModelInputProtocol {
    var word: CurrentValueSubject<String?, Never> { get }
    var wordsCounter: CurrentValueSubject<String?, Never> { get }
    var correctAnswers: CurrentValueSubject<Int, Never> { get }
    var isAnswerHidden: CurrentValueSubject<Bool, Never> { get }
    var message: CurrentValueSubject<(String, UIColor)?, Never> { get }
    var clearInputPublisher: AnyPublisher<Void, Never> { get }
    var progress: CurrentValueSubject<Float, Never> { get }
}

enum WritingViewModelAction {
    case check(String)
    case answer
}

protocol WritingViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<WritingViewModelAction, Never> { get }
}

typealias WritingViewModelProtocol =
    WritingViewModelInputProtocol &
    WritingViewModelOutputProtocol

final class WritingViewModel: WritingViewModelProtocol {
    
    // MARK: - Public properties
    
    var word: CurrentValueSubject<String?, Never>
    var wordsCounter: CurrentValueSubject<String?, Never>
    var correctAnswers: CurrentValueSubject<Int, Never>
    var isAnswerHidden: CurrentValueSubject<Bool, Never>
    var message: CurrentValueSubject<(String, UIColor)?, Never>
    var clearInputPublisher: AnyPublisher<Void, Never> {
        clearInputSubject.eraseToAnyPublisher()
    }
    var progress: CurrentValueSubject<Float, Never>
    var actionSubject: PassthroughSubject<WritingViewModelAction, Never>
    
    // MARK: - Private properties
    
    private let router: WritingCoordinatorProtocol
    private let words: [WritingWord]
    private var currentWord: WritingWord {
        willSet {
            wordsCounter.value = String(words.filter({ !$0.isLearned }).count)
            isAnswerHidden.value = true
            progress.value = currentProgress
            clearInputSubject.send()
        }
        didSet {
            word.value = currentWord.term
        }
    }
    private var currentProgress: Float {
        Float(words.map({ $0.correctCounter }).reduce(0, +)) / Float(words.count * 2)
    }
    private var clearInputSubject: PassthroughSubject<Void, Never>
    private var actionPublisher: AnyPublisher<WritingViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    private var cancellables: [AnyCancellable?]
    
    // MARK: - Init
    
    init(router: WritingCoordinatorProtocol, words: [Word]) {
        self.router = router
        
        self.words = words.map({ WritingWord(word: $0) })
        self.currentWord = self.words.randomElement()!
        
        self.word = .init(currentWord.term)
        self.wordsCounter = .init("\(words.count)")
        self.correctAnswers = .init(0)
        self.message = .init(nil)
        self.isAnswerHidden = .init(true)
        self.clearInputSubject = .init()
        self.progress = .init(.zero)
        self.actionSubject = .init()
        self.cancellables = []
        
        self.bindView()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
            actionPublisher.sink(receiveValue: { [weak self] action in
                switch action {
                case .check(let text):
                    self?.checkUserInput(text)
                case .answer:
                    self?.showAnswer()
                }
            })
        ]
    }
    
    private func getRandomWord() throws -> WritingWord {
        if let learnedWords = words.filter({ !$0.isLearned }).randomElement() {
            return learnedWords
        } else {
            throw WritingViewModelError.wordsAreLearned
        }
    }
    
    // MARK: - Actions
    
    private func checkUserInput(_ string: String) {
        if string.lowercased() == currentWord.definition.lowercased() {
            message.value = ("Correct!", .green)
            currentWord.markCorrect()
            do {
                currentWord = try getRandomWord()
            } catch {
                self.router.close()
            }
        } else {
            message.value = ("Incorrect!", .red)
            currentWord.markIncorrect()
        }
        
        if currentWord.isFailed {
            isAnswerHidden.value = false
        }
        
        correctAnswers.value = currentWord.correctCounter
    }
    
    private func showAnswer() {
        word.value = currentWord.definition
    }
    
}


