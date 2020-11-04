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
    private let userSession: SessionInfoProtocol & SessionStatePublisherProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    private let coreDataStack: CoreDataClearableProtocol
    private let mediaDownloader: MediaDownloadableProtocol
    
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
         userSession: SessionInfoProtocol & SessionStatePublisherProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol,
         coreDataStack: CoreDataClearableProtocol,
         mediaDownloader: MediaDownloadableProtocol) {
        self.router = router
        self.userSession = userSession
        self.dataProvider = dataProvider
        self.coreDataStack = coreDataStack
        self.mediaDownloader = mediaDownloader
        
        self.userImage = .init(nil)
        
        self.bindUserSession()
        self.setupNotifications()
        
        self.setupEmptySection(&tableSections)
        self.setupMyWorkSection(&tableSections)
        self.setupFavoritesSection(&tableSections)
        
        self.downloadUserPhoto()
        self.fetchFavoriteVocabularies()
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
        if let _ = userSession.userId {
            router.navigateToUserProfile()
        } else {
            router.navigateToLogin()
        }
    }
    
    // MARK: - Private methods
    
    private func bindUserSession() {
        userSession.sessionStatePublisher.sink(receiveValue: { [weak self] (state) in
            switch state {
            case .didUserLogin:
                self?.downloadUserPhoto()
                self?.fetchFavoriteVocabularies()
            case .didUserLogout:
                self?.clearUserCash()
            }
        }).store(in: &cancellables)
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
    
    private func fetchFavoriteVocabularies() {
        guard let userId = userSession.userId else { return }
        
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
    
    private func downloadUserPhoto() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.userImage.rawValue), let image = UIImage(data: data) {
            userImage.value = image
        } else if let photoURL = userSession.photoURL {
            mediaDownloader.downloadMedia(url: photoURL, onSucces: { (data) in
                if let image = UIImage(data: data)  {
                    UserDefaults.standard.set(data, forKey: UserDefaultsKey.userImage.rawValue)
                    self.userImage.value = image
                } else {
                    self.userImage.value = SFSymbols.personCircle()
                }
            }) { (error) in
                self.userImage.value = SFSymbols.personCircle()
                self.router.showError(error)
            }
        } else {
            userImage.value = SFSymbols.personCircle()
        }
    }
    
    private func clearUserCash() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
        userImage.value = SFSymbols.personCircle()
        
        setEmptyFavoritesSection()
        coreDataStack.clear()
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
