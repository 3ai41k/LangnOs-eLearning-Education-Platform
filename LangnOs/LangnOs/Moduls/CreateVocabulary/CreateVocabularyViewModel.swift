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
    private let dataProvider: DataProviderCreatingProtocol
    private let userSession: SessionInfoProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Init
    
    init(router: CreateVocabularyCoordinatorProtocol,
         dataProvider: DataProviderCreatingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.title = .init("New vocabulary".localize)
        
        self.setupVocabularyInfoSection(&tableSections)
        self.setupWordsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupVocabularyInfoSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [
            GeneralInfoCellViewModel()
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
        let cellViewModel = CreateWordCellViewModel()
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
                case let cell as GeneralInfoCellViewModel:
                    generalInfo = cell.vocabularyGeneralInfo
                case let cell as CreateWordCellViewModel:
                    if !cell.word.isEmpty {
                        words.append(cell.word)
                    }
                default:
                    break
                }
            })
        })
        
        if generalInfo.isEmpty {
            router.showAlert(title: "Sorry!",
                             message: "General information is empty. Because of this we could not create this vocabulary. Please, enter name and category",
                             actions: [OkAlertAction(handler: { })])
        } else {
            guard let userId = userSession.userId else {
                router.showAlert(title: "Sorry!",
                                 message: "You are not authorized",
                                 actions: [OkAlertAction(handler: { })])
                return
            }
            
            router.showActivity()
            
            let vocabulary = Vocabulary(userId: userId,
                                        title: generalInfo.name,
                                        category: generalInfo.category,
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
    }
    
    func closeAction() {
        router.close()
    }
    
}
