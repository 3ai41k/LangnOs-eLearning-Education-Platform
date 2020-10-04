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
    
    private let router: CreateVocabularyNavigationProtocol
    
    // MARK: - Init
    
    init(router: CreateVocabularyNavigationProtocol) {
        self.router = router
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
}

// MARK: - VocabularyViewModelInputProtocol

extension CreateVocabularyViewModel: CreateVocabularyViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let closeButtonModel = BarButtonDrivableModel(title: "Close".localize,
                                                      style: .plain,
                                                      target: self,
                                                      selector: #selector(didCloseTouched))
        return NavigationItemDrivableModel(title: "Create Vocabulary".localize,
                                           leftBarButtonDrivableModels: [closeButtonModel],
                                           rightBarButtonDrivableModels: [])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: false,
                                   backgroundColor: .white,
                                   prefersLargeTitles: false)
    }
    
}
