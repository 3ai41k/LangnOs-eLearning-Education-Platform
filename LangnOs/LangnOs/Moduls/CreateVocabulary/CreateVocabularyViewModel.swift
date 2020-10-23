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
        let sectionViewModel = TableSectionViewModel(cells: [
            VocabularyGeneralInfoViewModel()
        ])
        tableSections.append(sectionViewModel)
    }
    
    private func setupWordsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [
            createWordCellViewModel()
        ])
        tableSections.append(sectionViewModel)
    }
    
    private func addWordRow() {
        let cellViewModel = createWordCellViewModel()
        tableSections[SectionType.words.rawValue].cells.value.append(cellViewModel)
    }
    
    private func addImage() {
        print(#function)
    }
    
    private func createWordCellViewModel() -> CellViewModelProtocol {
        let cellViewModel = VocabularyWordCellViewModel()
        cellViewModel.addHandler = { [weak self] in self?.addWordRow() }
        cellViewModel.imageHandler = { [weak self] in self?.addImage() }
        return cellViewModel
    }
    
}

// MARK: - CreateVocabularyViewModelOutputProtocol

extension CreateVocabularyViewModel {
    
    func doneAction() {
        var generalInfo: VocabularyGeneralInfo = .empty
        var words: [Word] = []
        
        tableSections.forEach({ section in
            section.cells.value.forEach({ cell in
                switch cell {
                case let cell as VocabularyGeneralInfoViewModel:
                    generalInfo = cell.vocabularyGeneralInfo
                case let cell as VocabularyWordCellViewModel:
                    words.append(cell.word)
                default:
                    break
                }
            })
        })
        
        router.finish(generalInfo, words: words)
    }
    
    func closeAction() {
        router.close()
    }
    
}
