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
    private let storage: FirebaseStorageUploadingProtocol
    private let userSession: SessionInfoProtocol
    
    private var generalInfo: VocabularyGeneralInfo
    
    // MARK: - Init
    
    init(router: CreateVocabularyCoordinatorProtocol,
         dataProvider: FirebaseDatabaseCreatingProtocol,
         storage: FirebaseStorageUploadingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.storage = storage
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
        guard let userId = userSession.currentUser?.id else { return }
        
        var vocabulary = Vocabulary(userId: userId,
                                    title: generalInfo.name,
                                    category: generalInfo.category,
                                    isPrivate: generalInfo.isPrivate)
        
        router.showActivity()
        uploadTermImages(userId: userId, vocabularyId: vocabulary.id) {
            vocabulary.words = self.getAllWords()
            
            let request = VocabularyCreateRequest(vocabulary: vocabulary)
            self.dataProvider.create(request: request, onSuccess: {
                self.router.closeActivity()
                self.router.didCreateVocabulary(vocabulary)
            }) { (error) in
                self.router.closeActivity()
                self.router.showError(error)
            }
        }
    }
    
    func closeAction() {
        router.close()
    }
    
    // MARK: - Private methods
    
    private func uploadTermImages(userId: String, vocabularyId: String, completiom: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        tableSections[SectionType.words.rawValue].cells.value.forEach({
            ($0 as? CreateWordCellViewModel)?.uploadImage(userId: userId, vocabularyId: vocabularyId, dispatchGroup: dispatchGroup)
        })
        dispatchGroup.notify(queue: .main, execute: completiom)
    }
    
    private func getAllWords() -> [Word] {
        tableSections[SectionType.words.rawValue].cells.value.compactMap({
            ($0 as? CreateWordCellViewModel)?.word
        })
    }
    
    private func setupWordsSection() {
        let sectionViewModel = TableSectionViewModel(cells: [
            createWordCellViewModel()
        ])
        tableSections.append(sectionViewModel)
    }
    
    private func createWordCellViewModel() -> CellViewModelProtocol {
        let cellViewModel = CreateWordCellViewModel(storage: storage)
        cellViewModel.addHandler = { [weak self] in self?.addWordRow() }
        cellViewModel.imageHandler = { [weak self] in self?.addImageToTheTerm($0) }
        return cellViewModel
    }
    
    private func addWordRow() {
        let cellViewModel = createWordCellViewModel()
        tableSections[SectionType.words.rawValue].cells.value.append(cellViewModel)
    }
    
    private func addImageToTheTerm(_ didImageSelect: @escaping (UIImage) -> Void) {
        router.navigateToImagePicker(sourceType: .photoLibrary, didImageSelect: didImageSelect)
    }
    
}
