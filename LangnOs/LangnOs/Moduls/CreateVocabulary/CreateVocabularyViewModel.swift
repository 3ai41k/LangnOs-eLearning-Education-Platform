//
//  CreateVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol CreateVocabularyViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

final class CreateVocabularyViewModel: UniversalTableViewModelProtocol {
    
    // MARK: - Private properties
    
    private let userInfo: UserInfoProtocol
    private let dataFacade: DataFacadeCreatingProtocol
    private let router: CreateVocabularyCoordinatorProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Public properties
    
    var tableSections: [UniversalTableSectionViewModelProtocol]
    
    // MARK: - Init
    
    init(userInfo: UserInfoProtocol,
         dataFacade: DataFacadeCreatingProtocol,
         router: CreateVocabularyCoordinatorProtocol) {
        self.userInfo = userInfo
        self.dataFacade = dataFacade
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
        let createWordTableViewCellViewModel = CreateWordTableViewCellViewModel { [weak self] in
            self?.addRowAction()
        }
        tableSections.append(UniversalTableSectionViewModel(cells: [createWordTableViewCellViewModel]))
    }
    
    private func createVocabulary() throws -> Vocabulary {
        var name = ""
        var category = ""
        var words: [Word] = []
        
        for section in tableSections {
            for cellViewModel in section.cells {
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
        
        guard let userId = userInfo.userId else {
            throw NSError(domain: "User is not authorized", code: 0, userInfo: nil)
        }
        
        let vocabulary = Vocabulary(userId: userId, title: name, category: category, words: words)
        if vocabulary.isEmpty {
            throw NSError(domain: "Vocabulary is Empty", code: 0, userInfo: nil)
        } else {
            return vocabulary
        }
    }
    
    // MARK: - Actions
    
    private func addRowAction() {
        let cellViewModel = CreateWordTableViewCellViewModel{ [weak self] in
            self?.addRowAction()
        }
        tableSections[SectionType.words.rawValue].cells.append(cellViewModel)
    }
    
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
            dataFacade.create(request: request) { (error) in
                if let error = error {
                    // FIT IT: Error handling
                    print(error.localizedDescription)
                } else {
                    self.router.closeActivity()
                    self.router.vocabularyDidCreate(vocabulary)
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
    
    var navigationBarDrivableModel: DrivableModelProtocol? {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .white,
                                   prefersLargeTitles: false)
    }
    
}
