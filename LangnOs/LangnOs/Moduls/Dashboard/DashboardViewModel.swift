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
    case myWork = 1
    case favorites
}

private enum RowType {
    case materials
    case statistic
    case vocabulary
    
    init?(indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            self = .materials
        case (1, 1):
            self = .statistic
        case (2, _):
            self = .vocabulary
        default:
            return nil
        }
    }
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
    private let userSession: SessionInfoProtocol & SessionSatePublisherProtocol
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
         userSession: SessionInfoProtocol & SessionSatePublisherProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.userSession = userSession
        self.dataProvider = dataProvider
        
        self.userImage = .init(nil)
        
        self.setupEmptySection(&tableSections)
        self.setupMyWorkSection(&tableSections)
        self.setupFavoritesSection(&tableSections)
        
        self.bindUserSession()
        self.setupNotifications()
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        guard let row = RowType(indexPath: indexPath) else { return }
        switch row {
        case .materials:
            router.navigateToMaterials()
        case .statistic:
            print(#function)
        case .vocabulary:
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
    
    private func bindUserSession() {
        userSession.sessionSatePublisher.sink { [weak self] (state) in
            self?.updateUserPhoto()
            
            switch state {
            case .login, .logout:
                self?.fetchFavoriteVocabularies()
            case .changePhoto:
                break
            }
        }.store(in: &cancellables)
    }
    
    private func setupNotifications() {
        NotificationCenter.default
            .publisher(for: .reachabilityChanged)
            .compactMap({ $0.object as? Reachability })
            .map({ $0.connection })
            .sink { [weak self] in
                self?.titleViewStateSubject.send($0 == .unavailable ? .offline : .hide)
        }.store(in: &cancellables)
    }
    
    private func updateUserPhoto() {
        userSession.getUserPhoto(onSuccess: { (image) in
            self.userImage.value = image != nil ? image : SFSymbols.personCircle()
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    private func fetchFavoriteVocabularies() {
        guard let userId = userSession.userInfo.id else {
            setEmptyFavoritesSection()
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
    
    // MARK: - Table View Configuration
    
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
