//
//  VocabularySettingsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol VocabularySettingsViewModelInputProtocol {
    
}

protocol VocabularySettingsViewModelOutputProtocol {
    func closeAction()
}

typealias VocabularySettingsViewModelProtocol =
    VocabularySettingsViewModelInputProtocol &
    VocabularySettingsViewModelOutputProtocol &
    UniversalTableViewModelProtocol

enum VocabularySettingsRowAction {
    case rename
    case resetStatistic
    case delete
}

final class VocabularySettingsViewModel: UniversalTableViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularySettingsCoordinatorProtocol
    private let actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>
    
    // MARK: - Init
    
    init(router: VocabularySettingsCoordinatorProtocol,
         actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>) {
        self.router = router
        self.actionSubject = actionSubject
        
        self.setupGeneralSection(&tableSections)
        self.setupDeleteSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        router.close {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                self.actionSubject.send(.rename)
            case (0, 1):
                self.actionSubject.send(.resetStatistic)
            default:
                break
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupGeneralSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Rename", image: SFSymbols.edit(), color: .systemPurple),
            ColoredImageCellViewModel(text: "Reset statistic", image: SFSymbols.reset(), color: .systemOrange)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupDeleteSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ButtonCellViewModel(title: "Delete", titleColor: .systemRed, buttonHandler: { [weak self] in self?.deleteAction() })
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    // MARK: - Actions
    
    private func deleteAction() {
        router.close {
            self.actionSubject.send(.delete)
        }
    }
    
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


