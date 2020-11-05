//
//  CreateVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol CreateVocabularyViewModelInputProtocol {
    var title: String { get }
    var categoryButtonTitle: CurrentValueSubject<String?, Never> { get }
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

private enum SectionType: Int {
    case words
}

private struct VocabularyGeneralInfo {
    var name = ""
    var category: Category = .entertainment
    var isPrivate = false
}

final class CreateVocabularyViewModel: CreateVocabularyViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "New vocabulary".localize
    }
    var categoryButtonTitle: CurrentValueSubject<String?, Never>
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: CreateVocabularyCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseCreatingProtocol
    private let userSession: SessionInfoProtocol
    
    private var generalInfo: VocabularyGeneralInfo
    
    // MARK: - Init
    
    init(router: CreateVocabularyCoordinatorProtocol,
         dataProvider: FirebaseDatabaseCreatingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.categoryButtonTitle = .init("Select".localize)
        self.generalInfo = VocabularyGeneralInfo()
        
        self.setupWordsSection()
    }
    
    // MARK: - Public methods
    
    func setVocabularyName(_ name: String) {
        generalInfo.name = name
    }
    
    func setPrivate(_ isPrivate: Bool) {
        generalInfo.isPrivate = isPrivate
    }
    
    // ViewModel mustn't know about UI, but if you want to present popover you need to use sourceView.
    
    func selectCategory(sourceView: UIView) {
        router.showCategoryPopover(sourceView: sourceView) { (category) in
            self.generalInfo.category = category
            self.categoryButtonTitle.value = category.rawValue
        }
    }
    
    func doneAction() {
        guard let userId = userSession.userInfo.id else { return }
        
        let words = tableSections[SectionType.words.rawValue].cells.value.compactMap({
            ($0 as? CreateWordCellViewModel)?.word
        })
        
        let vocabulary = Vocabulary(userId: userId,
                                    title: generalInfo.name,
                                    category: generalInfo.category,
                                    isPrivate: generalInfo.isPrivate,
                                    words: words)
        
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
    
    private func setupWordsSection() {
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
