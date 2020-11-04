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

enum TitleViewState {
    case offline
    case hide
}

protocol DashboardViewModelInputProtocol {
    var title: String { get }
    var userImage: CurrentValueSubject<UIImage?, Never> { get }
    var titleViewStatePublisher: AnyPublisher<TitleViewState, Never> { get }
}

protocol DashboardViewModelOutputProtocol {
    func userProfileAction()
}

typealias DashboardViewModelProtocol =
    DashboardViewModelInputProtocol &
    DashboardViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case empty
    case myWork
    case favorites
}

final class DashboardViewModel: DashboardViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Home".localize
    }
    var userImage: CurrentValueSubject<UIImage?, Never>
    var titleViewStatePublisher: AnyPublisher<TitleViewState, Never> {
        titleViewStateSubject.eraseToAnyPublisher()
    }
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: DashboardCoordinatorProtocol
    private let userSession: SessionInfoProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    
    private var favoriteVocabularies: [Vocabulary] = [] {
        didSet {
            let cellViewModels = favoriteVocabularies.map({ MessageCellViewModel(message: $0.title) })
            self.tableSections[SectionType.favorites.rawValue].cells.value = cellViewModels
        }
    }
    
    private var cancellables: [AnyCancellable] = []
    private var titleViewStateSubject = PassthroughSubject<TitleViewState, Never>()
    
    // MARK: - Init
    
    init(router: DashboardCoordinatorProtocol,
         userSession: SessionInfoProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.userSession = userSession
        self.dataProvider = dataProvider
        
        self.userImage = .init(nil)
        
        self.setupEmptySection(&tableSections)
        self.setupMyWorkSection(&tableSections)
        self.setupFavoritesSection(&tableSections)
        
        self.setupNotifications()
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        guard let section = SectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .empty:
            break
        case .myWork:
            if indexPath.row == 0 { router.navigateToMaterials() }
        case .favorites:
            let vocabulary = favoriteVocabularies[indexPath.row]
            router.navigateToVocabulary(vocabulary)
        }
    }
    
    func userProfileAction() {
        if userSession.userInfo.isLogin == true {
            router.navigateToUserProfile()
        } else {
            router.navigateToLogin()
        }
    }
    
    // MARK: - Private methods
    
    private func setupNotifications() {
        NotificationCenter.default
            .publisher(for: .reachabilityChanged)
            .compactMap({ $0.object as? Reachability })
            .map({ $0.connection })
            .sink { [weak self] in
                self?.titleViewStateSubject.send($0 == .unavailable ? .offline : .hide)
        }.store(in: &cancellables)
        NotificationCenter.default
            .publisher(for: .didNewUserLogin)
            .sink { [weak self] _ in
                self?.setUserPhoto()
                self?.fetchFavoriteVocabularies()
        }.store(in: &cancellables)
        NotificationCenter.default
            .publisher(for: .didUserLogout)
            .sink { [weak self] _ in
                self?.setUserPhoto()
                self?.fetchFavoriteVocabularies()
        }.store(in: &cancellables)
        NotificationCenter.default
            .publisher(for: .didUserChangePhoto)
            .sink { [weak self] _ in
                self?.setUserPhoto()
        }.store(in: &cancellables)
    }
    
    private func setUserPhoto() {
        userSession.getUserPhoto { (image) in
            self.userImage.value = image != nil ? image : SFSymbols.personCircle()
        }
    }
    
    private func fetchFavoriteVocabularies() {
        guard let userId = userSession.userInfo.id else {
            self.setEmptyFavoritesSection()
            return
        }
        
        let request = FavoriteVocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            if vocabularies.isEmpty {
                self.setEmptyFavoritesSection()
            } else {
                self.favoriteVocabularies = vocabularies
            }
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    private func setupEmptySection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func setupMyWorkSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Materials", image: SFSymbols.meterials(), color: .systemGreen, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Statistic", image: SFSymbols.statistic(), color: .systemBlue, accessoryType: .disclosureIndicator)
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
        let headerViewModel = TitleSectionViewModel(text: "Favorites".localize,
                                                    buttonText: "Edit".localize,
                                                    buttonHandler: { [weak self] in
                                                        self?.editFavoritesSection()
                                                    })
        let sectionViewModel = TableSectionViewModel(headerView: headerViewModel,
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setEmptyFavoritesSection() {
        let cellViewModels = [
            MessageCellViewModel(message: "Add favorite sets here to have quick access at any time, without having to search".localize)
        ]
        tableSections[SectionType.favorites.rawValue].cells.value = cellViewModels
    }
    
    private func editFavoritesSection() {
        router.navigateToVocabularyList {
            self.fetchFavoriteVocabularies()
        }
    }
    
}
