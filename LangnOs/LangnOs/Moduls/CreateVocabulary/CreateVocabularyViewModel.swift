//
//  CreateVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol CreateVocabularyViewModelInputProtocol {
    var title: CurrentValueSubject<String?, Never> { get }
}

protocol CreateVocabularyViewModelOutputProtocol {
    func doneAction()
    func closeAction()
}

typealias CreateVocabularyViewModelProtocol =
    CreateVocabularyViewModelInputProtocol &
    CreateVocabularyViewModelOutputProtocol &
    UniversalTableViewModelProtocol

final class CreateVocabularyViewModel: CreateVocabularyViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String?, Never>
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: CreateVocabularyCoordinatorProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Init
    
    init(router: CreateVocabularyCoordinatorProtocol) {
        self.router = router
        
        self.title = .init("New vocabulary".localize)
        
        self.setupVocabularyInfoSection(&tableSections)
        self.setupWordsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupVocabularyInfoSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModel = VocabularyInfoTableViewCellViewModel()
        tableSections.append(TableSectionViewModel(cells: [cellViewModel]))
    }
    
    private func setupWordsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModel = createWordCellViewModel()
        tableSections.append(TableSectionViewModel(cells: [cellViewModel]))
    }
    
    private func createVocabulary() throws -> Vocabulary {
        var name = ""
        var category = ""
        var words: [Word] = []
        
        for section in tableSections {
            for cellViewModel in section.cells.value {
                switch cellViewModel {
                case let viewModel as VocabularyInfoTableViewCellViewModelProtocol:
                    name = viewModel.name
                    category = viewModel.category
                case let viewModel as CreateWordTableViewCellViewModelProtocol:
                    words.append(viewModel.word)
                default:
                    break
                }
            }
        }
        
        let vocabulary = Vocabulary(userId: "", title: name, category: category, words: words)
        if vocabulary.isEmpty {
            throw NSError(domain: "Vocabulary is Empty", code: 0, userInfo: nil)
        } else {
            return vocabulary
        }
    }
    
    private func createWordCellViewModel() -> CreateWordTableViewCellViewModel {
        let cellViewModel = CreateWordTableViewCellViewModel()
        cellViewModel.addNewWordHandler = { [weak self] in
            self?.addRowAction()
        }
        cellViewModel.addImageHandler = { [weak self] completion in
            self?.router.navigateToImagePicker(sourceType: .photoLibrary, didImageSelect: completion)
        }
        return cellViewModel
    }
    
    // MARK: - Actions
    
    private func addRowAction() {
        tableSections[SectionType.words.rawValue].cells.value.append(createWordCellViewModel())
    }
    
}

// MARK: - CreateVocabularyViewModelOutputProtocol

extension CreateVocabularyViewModel {
    
    func doneAction() {
        router.close()
    }
    
    func closeAction() {
        router.close()
    }
    
}
