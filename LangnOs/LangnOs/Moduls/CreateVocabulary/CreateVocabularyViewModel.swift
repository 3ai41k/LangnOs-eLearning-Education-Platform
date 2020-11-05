//
//  CreateVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CreateVocabularyViewModelInputProtocol {
    var title: String { get }
}

protocol CreateVocabularyViewModelOutputProtocol {
    func setVocabularyName(_ name: String)
    func setPrivate(_ isPrivate: Bool)
    func selectCategory(sourceView: UIView)
    func doneAction()
    func closeAction()
}

typealias CreateVocabularyViewModelProtocol =
    CreateVocabularyViewModelInputProtocol &
    CreateVocabularyViewModelOutputProtocol &
    UniversalTableViewModelProtocol

final class CreateVocabularyViewModel: CreateVocabularyViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "New vocabulary".localize
    }
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: CreateVocabularyCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseCreatingProtocol
    private let userSession: SessionInfoProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Init
    
    init(router: CreateVocabularyCoordinatorProtocol,
         dataProvider: FirebaseDatabaseCreatingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.setupWordsSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func setVocabularyName(_ name: String) {
        print(name)
    }
    
    func setPrivate(_ isPrivate: Bool) {
        print(isPrivate)
    }
    
    // ViewModel mustn't know about UI, but if you want to present popover you need to use sourceView.
    
    func selectCategory(sourceView: UIView) {
        router.showCategoryPopover(sourceView: sourceView)
    }
    
    func doneAction() {
        guard let userId = userSession.userInfo.id else { return }
        
        let vocabulary = Vocabulary(userId: userId, title: "Test", category: "Test", words: [Word(term: "Test1", definition: "Test1")])
        let request = VocabularyCreateRequest(vocabulary: vocabulary)
        dataProvider.create(request: request, onSuccess: {
            self.router.closeActivity()
            self.router.didCreateVocabulary(vocabulary)
        }) { (error) in
            self.router.closeActivity()
            self.router.showError(error)
        }
    }
    
    func closeAction() {
        router.close()
    }
    
    // MARK: - Private methods
    
    private func setupWordsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [
            createWordCellViewModel()
        ])
        tableSections.append(sectionViewModel)
    }
    
    private func createWordCellViewModel() -> CellViewModelProtocol {
        let cellViewModel = CreateWordCellViewModel()
        cellViewModel.addHandler = { [weak self] in self?.addWordRow() }
        cellViewModel.imageHandler = { [weak self] in self?.addImage() }
        return cellViewModel
    }
    
    private func addWordRow() {
        let cellViewModel = createWordCellViewModel()
        tableSections[SectionType.words.rawValue].cells.value.append(cellViewModel)
    }
    
    private func addImage() {
        print(#function)
    }
    
}
