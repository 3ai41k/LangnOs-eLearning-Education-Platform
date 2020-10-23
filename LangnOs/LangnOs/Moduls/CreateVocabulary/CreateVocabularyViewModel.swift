//
//  CreateVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth

protocol CreateVocabularyViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

final class CreateVocabularyViewModel: UniversalTableViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: CreateVocabularyCoordinatorProtocol
    private let user: User
    private let dataFacade: DataFacadeCreatingProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Init
    
    init(router: CreateVocabularyCoordinatorProtocol,
         user: User,
         dataFacade: DataFacadeCreatingProtocol) {
        self.router = router
        self.user = user
        self.dataFacade = dataFacade
        
        setupVocabularyInfoSection(&tableSections)
        setupWordsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupVocabularyInfoSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let vocabularyInfoTableViewCellViewModel = VocabularyInfoTableViewCellViewModel()
        tableSections.append(TableSectionViewModel(cells: [vocabularyInfoTableViewCellViewModel]))
    }
    
    private func setupWordsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        tableSections.append(TableSectionViewModel(cells: [createWordCellViewModel()]))
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
        
        let vocabulary = Vocabulary(userId: user.uid, title: name, category: category, words: words)
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
