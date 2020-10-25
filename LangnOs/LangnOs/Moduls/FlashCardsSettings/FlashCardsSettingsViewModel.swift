//
//  FlashCardsSettingsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

enum FlashCardsSettingsRowAction: Int {
    case changeLanguage
}

final class FlashCardsSettingsViewModel: VocabularySettingsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String?, Never>
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularySettingsCoordinatorProtocol
    private let actionSubject: PassthroughSubject<FlashCardsSettingsRowAction, Never>
    
    // MARK: - Init
    
    init(router: VocabularySettingsCoordinatorProtocol,
         actionSubject: PassthroughSubject<FlashCardsSettingsRowAction, Never>) {
        self.router = router
        self.actionSubject = actionSubject
        
        self.title = .init("Flash Cards Settings")
        
        self.setupSettingsSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        guard let rowType = FlashCardsSettingsRowAction(rawValue: indexPath.row) else { return }
        router.close {
            self.actionSubject.send(rowType)
        }
    }
    
    // MARK: - Private methods
    
    private func setupSettingsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Change language", image: SFSymbols.planet(), color: .systemTeal)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    // MARK: - Actions
    
    func closeAction() {
        router.close()
    }
    
}
