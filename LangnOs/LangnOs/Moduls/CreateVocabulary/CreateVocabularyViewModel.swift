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

final class CreateVocabularyViewModel {
    
    // MARK: - Private properties
    
    private let fireBaseDatabase: FirebaseDatabaseCreatingProtocol
    private let router: CreateVocabularyNavigationProtocol
    
    // MARK: - Init
    
    init(fireBaseDatabase: FirebaseDatabaseCreatingProtocol, router: CreateVocabularyNavigationProtocol) {
        self.fireBaseDatabase = fireBaseDatabase
        self.router = router
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
    @objc
    private func didCreateTouched() {
        let words: [Word] = [
            Word(term: "Test1", definition: "Test1"),
            Word(term: "Test2", definition: "Test2"),
            Word(term: "Test3", definition: "Test3"),
        ]
        let vocabulary = Vocabulary(title: "Test",
                                    category: "Test",
                                    words: words)
        let request = FirebaseDatabaseVocabularyCreateRequest(vocabulary: vocabulary)
        fireBaseDatabase.create(request: request) { (error) in
            // FIX IT
            print(error.localizedDescription)
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
