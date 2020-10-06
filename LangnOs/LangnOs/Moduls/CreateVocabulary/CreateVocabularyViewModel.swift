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

final class CreateVocabularyViewModel: UniversalSectionProtocol {
    
    // MARK: - Private properties
    
    private let fireBaseDatabase: FirebaseDatabaseCreatingProtocol
    private let router: CreateVocabularyNavigationProtocol & ActivityPresentableProtocol
    
    private enum SectionType: Int {
        case vocabularylInfo
        case words
    }
    
    // MARK: - Public properties
    
    var tableSections: [TableSectionViewModelProtocol]
    
    // MARK: - Init
    
    init(fireBaseDatabase: FirebaseDatabaseCreatingProtocol, router: CreateVocabularyNavigationProtocol & ActivityPresentableProtocol) {
        self.fireBaseDatabase = fireBaseDatabase
        self.router = router
        self.tableSections = []
        
        setupVocabularyInfoSection(&tableSections)
        setupWordsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupVocabularyInfoSection(_ tableSections: inout [TableSectionViewModelProtocol]) {
        let vocabularyInfoTableViewCellViewModel = VocabularyInfoTableViewCellViewModel()
        tableSections.append(UniversalTableSectionViewModel(title: nil, cells: [vocabularyInfoTableViewCellViewModel]))
    }
    
    private func setupWordsSection(_ tableSections: inout [TableSectionViewModelProtocol]) {
        let createWordTableViewCellViewModel = CreateWordTableViewCellViewModel()
        tableSections.append(UniversalTableSectionViewModel(title: nil, cells: [createWordTableViewCellViewModel]))
    }
    
    private func createVocabulary() -> Vocabulary {
        var vocabularyName = ""
        var words: [Word] = []
        
        for section in tableSections {
            for cellViewModel in section.cells {
                (cellViewModel as? ResignibleRespondersProtocol)?.resignResponders()
                switch cellViewModel {
                case let viewModel as VocabularyInfoTableViewCellViewModelProtocol:
                    vocabularyName = viewModel.vocabularyName
                case let viewModel as CreateWordTableViewCellViewModelProtocol:
                    words.append(viewModel.word)
                default:
                    break
                }
            }
        }
        
        return Vocabulary(title: vocabularyName, category: "Test", words: words)
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
    @objc
    private func didCreateTouched() {
        router.showActivity()
        
        let request = FirebaseDatabaseVocabularyCreateRequest(vocabulary: createVocabulary())
        fireBaseDatabase.create(request: request) { (error) in
            if let error = error {
                // FIT IT: Error handling
                print(error.localizedDescription)
            } else {
                self.router.closeActivity()
                self.router.close()
            }
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
