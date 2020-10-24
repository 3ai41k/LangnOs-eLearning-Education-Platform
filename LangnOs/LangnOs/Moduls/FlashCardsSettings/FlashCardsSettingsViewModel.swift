//
//  FlashCardsSettingsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

final class FlashCardsSettingsViewModel: VocabularySettingsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String?, Never>
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularySettingsCoordinatorProtocol
    
    // MARK: - Init
    
    init(router: VocabularySettingsCoordinatorProtocol) {
        self.router = router
        
        self.title = .init("Flash Cards Settings")
        
        self.setupSettingsSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        
    }
    
    // MARK: - Private methods
    
    private func setupSettingsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Language", image: SFSymbols.planet(), color: .systemTeal)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    // MARK: - Actions
    
    // MARK: - VocabularySettingsViewModelOutputProtocol
    
    func closeAction() {
        router.close()
    }
    
}
