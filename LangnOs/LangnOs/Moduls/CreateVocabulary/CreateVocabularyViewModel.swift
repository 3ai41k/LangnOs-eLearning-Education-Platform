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

final class CreateVocabularyViewModel: UniversalTableViewViewModel {
    
    // MARK: - Private properties
    
    private let fireBaseDatabase: FirebaseDatabaseCreatingProtocol
    private let router: CreateVocabularyNavigationProtocol & ActivityPresentableProtocol
    private var cellViewModels: [CreateWordTableViewCellViewModelProtocol]
    
    // MARK: - Public properties
    
    var numberOfRows: Int {
        cellViewModels.count
    }
    
    var reloadData: (() -> Void)?
    
    // MARK: - Init
    
    init(fireBaseDatabase: FirebaseDatabaseCreatingProtocol, router: CreateVocabularyNavigationProtocol & ActivityPresentableProtocol) {
        self.fireBaseDatabase = fireBaseDatabase
        self.router = router
        self.cellViewModels = [CreateWordTableViewCellViewModel()]
    }
    
    // MARK: - Public methods
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol {
        cellViewModels[indexPath.row]
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
    @objc
    private func didCreateTouched() {
        let words = cellViewModels.map({ $0.word })
        let vocabulary = Vocabulary(title: "Test", category: "Test", words: words)
        let request = FirebaseDatabaseVocabularyCreateRequest(vocabulary: vocabulary)
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
        cellViewModels.append(cellViewModel)
        reloadData?()
    }
    
}
