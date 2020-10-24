//
//  VocabularySettingsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularySettingsViewModelInputProtocol {
    
}

protocol VocabularySettingsViewModelOutputProtocol {
    func closeAction()
}

protocol VocabularySettingsViewModelBindingProtocol {
    
}

typealias VocabularySettingsViewModelProtocol =
    VocabularySettingsViewModelInputProtocol &
    VocabularySettingsViewModelOutputProtocol &
    VocabularySettingsViewModelBindingProtocol

final class VocabularySettingsViewModel: VocabularySettingsViewModelBindingProtocol {
    
    // MARK: - Public properties
    
    
    
    // MARK: - Private properties
    
    private let router: VocabularySettingsCoordinatorProtocol
    
    // MARK: - Init
    
    init(router: VocabularySettingsCoordinatorProtocol) {
        self.router = router
    }
    
    // MARK: - Public methods
    
    
    
    // MARK: - Private methods
    
    
    
}

// MARK: - VocabularySettingsViewModelInputProtocol

extension VocabularySettingsViewModel: VocabularySettingsViewModelInputProtocol {
    
}

// MARK: - VocabularySettingsViewModelOutputProtocol

extension VocabularySettingsViewModel: VocabularySettingsViewModelOutputProtocol {
    
    func closeAction() {
        router.close()
    }
    
}


