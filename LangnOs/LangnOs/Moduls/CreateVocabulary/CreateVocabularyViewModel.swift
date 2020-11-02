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
    var title: CurrentValueSubject<String?, Never> { get }
}

protocol CreateVocabularyViewModelOutputProtocol {
    func doneAction()
    func selectCategory(sourceView: UIView) -> String
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
        
        self.setupWordsSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func doneAction() {
        //        var generalInfo: VocabularyGeneralInfo = .empty
        //        var words: [Word] = []
        //
        //        tableSections.forEach({ section in
        //            section.cells.value.forEach({ cell in
        //                switch cell {
        //                case let cell as GeneralInfoCellViewModel:
        //                    generalInfo = cell.vocabularyGeneralInfo
        //                case let cell as CreateWordCellViewModel:
        //                    if !cell.word.isEmpty {
        //                        words.append(cell.word)
        //                    }
        //                default:
        //                    break
        //                }
        //            })
        //        })
        //
        //        if generalInfo.isEmpty {
        //            router.showAlert(title: "Sorry!",
        //                             message: "General information is empty. Because of this we could not create this vocabulary. Please, enter name and category",
        //                             actions: [OkAlertAction(handler: { })])
        //        } else {
        //            guard let userId = userSession.userId else {
        //                router.showAlert(title: "Sorry!",
        //                                 message: "You are not authorized",
        //                                 actions: [OkAlertAction(handler: { })])
        //                return
        //            }
        //
        //            router.showActivity()
        //
        //            let vocabulary = Vocabulary(userId: userId,
        //                                        title: generalInfo.name,
        //                                        category: generalInfo.category,
        //                                        words: words)
        //
        //            let request = VocabularyCreateRequest(vocabulary: vocabulary)
        //            dataProvider.create(request: request, onSuccess: {
        //                self.router.closeActivity()
        //                self.router.didCreateVocabulary(vocabulary)
        //            }) { (error) in
        //                self.router.closeActivity()
        //                self.router.showError(error)
        //            }
        //        }
    }
    
    // ViewModel mustn't know about UI, but if you want to present popover you need to use sourceView.
    // This method is an exception
    
    func selectCategory(sourceView: UIView) -> String {
        router.showCategoryPopover(sourceView: sourceView)
        
        
        return "SAS"
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
