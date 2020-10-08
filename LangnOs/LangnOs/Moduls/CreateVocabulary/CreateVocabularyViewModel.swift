//
//  CreateVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol CreateVocabularyViewModelInputProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol { get }
}

protocol CreateVocabularyViewModelOutputProtocol {
    func addRowAction()
}

final class CreateVocabularyViewModel: UniversalTableViewSectionProtocol {
    
    // MARK: - Private properties
    
    private let fireBaseDatabase: FirebaseDatabaseCreatingProtocol
    private let router: CreateVocabularyNavigationProtocol & ActivityPresentableProtocol & AlertPresentableProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Public properties
    
    var tableSections: [UniversalTableSectionViewModelProtocol]
    
    // MARK: - Init
    
    init(fireBaseDatabase: FirebaseDatabaseCreatingProtocol,
         router: CreateVocabularyNavigationProtocol & ActivityPresentableProtocol & AlertPresentableProtocol) {
        self.fireBaseDatabase = fireBaseDatabase
        self.router = router
        self.tableSections = []
        
        setupVocabularyInfoSection(&tableSections)
        setupWordsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupVocabularyInfoSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        let vocabularyInfoTableViewCellViewModel = VocabularyInfoTableViewCellViewModel()
        tableSections.append(UniversalTableSectionViewModel(cells: [vocabularyInfoTableViewCellViewModel]))
    }
    
    private func setupWordsSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        let createWordTableViewCellViewModel = CreateWordTableViewCellViewModel()
        tableSections.append(UniversalTableSectionViewModel(cells: [createWordTableViewCellViewModel]))
    }
    
    private func createVocabulary() throws -> Vocabulary {
        var name = ""
        var category = ""
        var words: [Word] = []
        
        for section in tableSections {
            for cellViewModel in section.cells {
                (cellViewModel as? ResignibleRespondersProtocol)?.resignResponders()
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
        
        let vocabulary = Vocabulary(title: name, category: category, words: words)
        if vocabulary.isEmpty {
            throw NSError(domain: "Vocabulary is Empty", code: 0, userInfo: nil)
        } else {
            return vocabulary
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
    @objc
    private func didCreateTouched() {
        do {
            let vocabulary = try createVocabulary()
            let request = VocabularyCreateRequest(vocabulary: vocabulary)
            
            router.showActivity()
            fireBaseDatabase.create(request: request) { (error) in
                if let error = error {
                    // FIT IT: Error handling
                    print(error.localizedDescription)
                } else {
                    self.router.closeActivity()
                    self.router.close()
                }
            }
        } catch {
            router.showAlert(title: "Attention!", message: error.localizedDescription, actions: [
                OkAlertAction(handler: {
                    // TO DO: Add first cell respoder
                })
            ])
        }
    }
    
}

// MARK: - VocabularyViewModelInputProtocol

extension CreateVocabularyViewModel: CreateVocabularyViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let closeButtonModel = BarButtonDrivableModel(title: "Close".localize,
                                                      style: .plain,
                                                      target: self,
                                                      selector: #selector(didCloseTouched))
        let createButtonModel = BarButtonDrivableModel(title: "Create".localize,
                                                       style: .done,
                                                       target: self,
                                                       selector: #selector(didCreateTouched))
        return NavigationItemDrivableModel(title: "Create Vocabulary".localize,
                                           leftBarButtonDrivableModels: [closeButtonModel],
                                           rightBarButtonDrivableModels: [createButtonModel])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: false,
                                   backgroundColor: .white,
                                   prefersLargeTitles: false)
    }
    
}

// MARK: - CreateVocabularyViewModelOutputProtocol

extension CreateVocabularyViewModel: CreateVocabularyViewModelOutputProtocol {
    
    func addRowAction() {
        let cellViewModel = CreateWordTableViewCellViewModel()
        tableSections[SectionType.words.rawValue].cells.append(cellViewModel)
    }
    
}
