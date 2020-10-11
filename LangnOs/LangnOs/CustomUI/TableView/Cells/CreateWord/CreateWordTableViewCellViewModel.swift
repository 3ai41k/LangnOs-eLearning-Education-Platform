//
//  CreateWordTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol CreateWordTableViewCellViewModelProtocol: CellViewModelProtocol {
    var word: Word { get }
}

protocol CreateWordTableViewCellInputProtocol {
    var term: String { get }
    var definition: String { get }
    var toolbarDrivableModel: DrivableModelProtocol { get }
}

protocol CreateWordTableViewCellOutputProtocol {
    func setTerm(_ term: String)
    func setDefinition(_ definition: String)
}

final class CreateWordTableViewCellViewModel: CreateWordTableViewCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var word: Word
    
    // MARK: - Private properties
    
    private var addNewWordHandler: () -> Void
    
    // MARK: - Init
    
    init(addNewWordHandler: @escaping () -> Void) {
        self.addNewWordHandler = addNewWordHandler
        self.word = Word(term: "", definition: "")
    }
    
    // MARK: - Action
    
    @objc
    private func didAddTouch() {
        addNewWordHandler()
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
                                   selector: #selector(didAddTouch))
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

