//
//  CreateWordTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol CreateWordTableViewCellViewModelProtocol: CellViewModelProtocol {
    var word: Word { get }
}

protocol CreateWordTableViewCellInputProtocol {
    var term: String { get }
    var definition: String { get }
    var image: CurrentValueSubject<UIImage?, Never> { get }
    var setBecomeFirstResponder: AnyPublisher<Void, Never> { get }
    var toolbarDrivableModel: DrivableModelProtocol { get }
}

protocol CreateWordTableViewCellOutputProtocol {
    func setTerm(_ term: String)
    func setDefinition(_ definition: String)
}

final class CreateWordTableViewCellViewModel: CreateWordTableViewCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var word: Word
    var addNewWordHandler: (() -> Void)?
    var addImageHandler: ((@escaping (UIImage) -> Void) -> Void)?
    
    var image = CurrentValueSubject<UIImage?, Never>(nil)
    var setBecomeFirstResponder: AnyPublisher<Void, Never> {
        setBecomeFirstResponderSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private properties
    
    private var setBecomeFirstResponderSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    init() {
        self.word = Word(term: "", definition: "")
        
        self.bindView()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        
    }
    
    // MARK: - Action
    
    @objc
    private func didAddTouch() {
        addNewWordHandler?()
    }
    
    @objc
    private func didAddImageTouch() {
        addImageHandler? { image in
            self.image.value = image
        }
    }
    
}

// MARK: - CreateWordTableViewCellInputProtocol

extension CreateWordTableViewCellViewModel: CreateWordTableViewCellInputProtocol {
    
    var term: String {
        word.term
    }
    
    var definition: String {
        word.definition
    }
    
    var toolbarDrivableModel: DrivableModelProtocol {
        ToolbarDrivableModel(barButtonDrivableModels: [
            BarButtonDrivableModel(title: "Add".localize,
                                   style: .plain,
                                   target: self,
                                   selector: #selector(didAddTouch)),
            BarButtonDrivableModel(title: "Image".localize,
                                   style: .plain,
                                   target: self,
                                   selector: #selector(didAddImageTouch))
        ])
    }
    
}

// MARK: - CreateWordTableViewCellOutputProtocol

extension CreateWordTableViewCellViewModel: CreateWordTableViewCellOutputProtocol {
    
    func setTerm(_ term: String) {
        self.word = Word(term: term, definition: word.definition)
    }
    
    func setDefinition(_ definition: String) {
        self.word = Word(term: word.term, definition: definition)
    }
    
}

