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
        let cellViewModel = VocabularyGeneralInfoViewModel()
        tableSections.append(TableSectionViewModel(cells: [cellViewModel]))
    }
    
    private func setupWordsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModel = VocabularyWordCellViewModel()
        tableSections.append(TableSectionViewModel(cells: [cellViewModel]))
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
