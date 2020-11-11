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
    var title: CurrentValueSubject<String?, Never> { get }
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
    case favorite
    case delete
}

final class VocabularySettingsViewModel: VocabularySettingsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String?, Never>
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularySettingsCoordinatorProtocol
    private let actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>
    
    // MARK: - Init
    
    init(router: VocabularySettingsCoordinatorProtocol,
         actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>) {
        self.router = router
        self.actionSubject = actionSubject
        
        self.title = .init("Vocabulary Settings".localize)
        
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
            case (0, 2):
                self.actionSubject.send(.favorite)
            default:
                break
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupGeneralSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Rename", image: SFSymbols.edit(), color: .systemPurple),
            ColoredImageCellViewModel(text: "Reset statistic", image: SFSymbols.reset(), color: .systemOrange),
            ColoredImageCellViewModel(text: "Add to favorite", image: SFSymbols.heart(for: .normal), color: .systemRed)
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
    
    // MARK: - VocabularySettingsViewModelOutputProtocol
    
    func closeAction() {
        router.close()
    }
    
}


