//
//  DashboardViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine
import Reachability

protocol NavigatableViewModelProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol? { get }
}

extension NavigatableViewModelProtocol {
    var navigationBarDrivableModel: DrivableModelProtocol? { nil }
}

protocol DashboardViewModelInputProtocol {
    var title: CurrentValueSubject<String, Never> { get }
    var isOfflineTitleHiddenPublisher: AnyPublisher<Bool, Never> { get }
}

protocol DashboardViewModelOutputProtocol {
    func userProfileAction()
    func fetchFavoriteVocabulary()
    func refreshData(completion: () -> Void)
}

typealias DashboardViewModelProtocol =
    DashboardViewModelInputProtocol &
    DashboardViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum RowType: Int {
    case materials
    case statistic
    case courses
    case something
}

private enum SectionType: Int {
    case empty
    case myWork
    case favorites
}

final class DashboardViewModel: DashboardViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String, Never>
    var isOfflineTitleHiddenPublisher: AnyPublisher<Bool, Never> {
        isOfflineTitleHiddenSubject.eraseToAnyPublisher()
    }
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: DashboardCoordinatorProtocol
    private let contex: UserSessesionPublisherContextProtocol
    private let securityManager: SecurityManager
    private let dataProvider: DataProviderFetchingProtocol
    
    private var cancellables: [AnyCancellable] = []
    private var isOfflineTitleHiddenSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: - Init
    
    init(router: DashboardCoordinatorProtocol,
         contex: UserSessesionPublisherContextProtocol,
         securityManager: SecurityManager,
         dataProvider: DataProviderFetchingProtocol) {
        self.router = router
        self.contex = contex
        self.securityManager = securityManager
        self.dataProvider = dataProvider
        
        self.title = .init("Home".localize)
        
        self.bindContext()
        self.setupNotifications()
        
        self.setupEmptySection(&tableSections)
        self.setupMyWorkSection(&tableSections)
        self.setupFavoritesSection(&tableSections)
    }
    
    deinit {
        self.removerNotifications()
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        guard indexPath.section == 1, let row = RowType(rawValue: indexPath.row) else { return }
        switch row {
        case .materials:
            self.router.navigateToMaterials()
        case .statistic:
            print("")
        case .courses:
            print("")
        case .something:
            print("")
        }
    }
    
    func userProfileAction() {
        router.navigateToUserProfile()
    }
    
    func fetchFavoriteVocabulary() {
        guard let userId = securityManager.user?.uid else { return }
        let request = FavoriteVocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            if vocabularies.isEmpty {
                self.setupAddToFavoriteCell()
            } else {
                self.setupFavoriteVocabularyCells(vocabularies)
            }
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    // MARK: FIX IT
    
    func refreshData(completion: () -> Void) {
        fetchFavoriteVocabulary()
        completion()
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        
    }
    
    private func setupNotifications() {
        NotificationCenter.default
            .publisher(for: .reachabilityChanged)
            .compactMap({ $0.object as? Reachability })
            .map({ $0.connection })
            .sink { [weak self] in
                self?.isOfflineTitleHiddenSubject.send($0 != .unavailable)
        }.store(in: &cancellables)
    }
    
    private func removerNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupEmptySection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func setupMyWorkSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Materials", image: SFSymbols.meterials(), color: .systemGreen, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Statistic", image: SFSymbols.statistic(), color: .systemBlue, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Courses", image: SFSymbols.book(), color: .systemPurple, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Something", image: SFSymbols.bookmark(for: .normal), color: .systemOrange, accessoryType: .disclosureIndicator)
        ]
        let sectionViewModel = TableSectionViewModel(headerView: TitleSectionViewModel(text: "My Work".localize),
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupFavoritesSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ActivityIndicatorCellViewModel()
        ]
        let sectionViewModel = TableSectionViewModel(headerView: TitleSectionViewModel(text: "Favorites".localize),
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupFavoriteVocabularyCells(_ vocabularies: [Vocabulary]) {
        let cellViewModels = vocabularies.map({ MessageCellViewModel(message: $0.title) })
        tableSections[SectionType.favorites.rawValue].cells.value = cellViewModels
    }
    
    private func setupAddToFavoriteCell() {
        let cellViewModels = [
            MessageCellViewModel(message: "Add favorite sets here to have quick access at any time, without having to search",
                                 buttonTitle: "Add to favorite",
                                 buttonHandler: { [weak self] in self?.router.navigateToVocabularyList() })
        ]
        let headerViewModel = TitleSectionViewModel(text: "Favorites".localize,
                                                    buttonText: "Edit".localize,
                                                    buttonHandler: { [weak self] in self?.router.navigateToVocabularyList() })
        let sectionViewModel = TableSectionViewModel(headerView: headerViewModel,
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections[SectionType.favorites.rawValue] = sectionViewModel
    }
    
}
