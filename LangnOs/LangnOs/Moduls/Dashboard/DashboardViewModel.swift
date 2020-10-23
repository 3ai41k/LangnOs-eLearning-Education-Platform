//
//  DashboardViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol NavigatableViewModelProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol? { get }
}

extension NavigatableViewModelProtocol {
    var navigationBarDrivableModel: DrivableModelProtocol? { nil }
}

protocol DashboardViewModelInputProtocol {
    var title: CurrentValueSubject<String, Never> { get }
}

enum DashboardViewModelAction {
    case createVocabulary
    case userProfile
}

protocol DashboardViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<DashboardViewModelAction, Never> { get }
}

typealias DashboardViewModelProtocol =
    DashboardViewModelInputProtocol &
    DashboardViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case myWork = 1
    case favorites
    case recent
}

final class DashboardViewModel: DashboardViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String, Never>
    var actionSubject = PassthroughSubject<DashboardViewModelAction, Never>()
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: DashboardCoordinatorProtocol
    private let contex: UserSessesionPublisherContextProtocol
    private let securityManager: SecurityManager
    private let dataFacade: DataFacadeFetchingProtocol
    
    private var cancellables: [AnyCancellable?] = []
    
    private var actionPublisher: AnyPublisher<DashboardViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    init(router: DashboardCoordinatorProtocol,
         contex: UserSessesionPublisherContextProtocol,
         securityManager: SecurityManager,
         dataFacade: DataFacadeFetchingProtocol) {
        self.router = router
        self.contex = contex
        self.securityManager = securityManager
        self.dataFacade = dataFacade
        
        self.title = .init("Home".localize)
        
        self.bindContext()
        self.bindView()
        
        self.setupEmptySection(&tableSections)
        self.setupMyWorkSection(&tableSections)
        self.setupFavoritesSection(&tableSections)
        self.setupRecentSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        guard let section = SectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .myWork:
            if indexPath.row == 0 {
                self.router.navigateToMaterials()
            }
        case .favorites:
            print("")
        case .recent:
            print("")
        }
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        cancellables = [
            
        ]
    }
    
    private func bindView() {
        cancellables = [
            actionPublisher.sink(receiveValue: { [weak self] (action) in
                switch action {
                case .createVocabulary:
                    print(#function)
                case .userProfile:
                    self?.router.navigateToUserProfile()
                }
            })
        ]
    }
    
    private func setupEmptySection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func setupMyWorkSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Materials", image: SFSymbols.bookmark(for: .normal), color: .systemGreen),
            ColoredImageCellViewModel(text: "Statistic", image: SFSymbols.bookmark(for: .normal), color: .systemBlue),
            ColoredImageCellViewModel(text: "Courses", image: SFSymbols.bookmark(for: .normal), color: .systemPurple),
            ColoredImageCellViewModel(text: "Something", image: SFSymbols.bookmark(for: .normal), color: .systemOrange)
        ]
        let sectionViewModel = TableSectionViewModel(headerView: TitleSectionViewModel(text: "My Work".localize),
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupFavoritesSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            MessageCellViewModel(message: "Add favorite sets here to have quick access at any time, without having to search",
                                 buttonTitle: "Add Favorites",
                                 buttonHandler: { [weak self] in self?.favoriteButtonTouch() })
        ]
        let sectionViewModel = TableSectionViewModel(headerView: TitleSectionViewModel(text: "Favorites".localize),
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupRecentSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            MessageCellViewModel(message: "Add favorite sets here to have quick access at any time, without having to search")
        ]
        let sectionViewModel = TableSectionViewModel(headerView: TitleSectionViewModel(text: "Recent".localize),
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    // MARK: - Action
    
    private func favoriteButtonTouch() {
        print(#function)
    }
    
}
