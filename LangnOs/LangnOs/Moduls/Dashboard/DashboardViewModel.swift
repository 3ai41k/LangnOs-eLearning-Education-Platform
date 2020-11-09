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
            favoriteVocabularies.isEmpty ?
                setupEmptyFavoriteVocabularySection() :
                setupFavoriteVocabularySection()
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
        
        self.appendEmptySection()
        self.appendMyWorkSection()
        self.appendFavoriteVocabularySection()
        
        self.bindUserSession()
        self.setupNotifications()
        
        self.updateUserPhoto()
        self.fetchFavoriteVocabulary()
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
        if userSession.currentUser != nil {
            router.navigateToUserProfile()
        } else {
            router.navigateToLogin()
        }
    }
    
    // MARK: - Private methods
    
    private func bindUserSession() {
        userSession.sessionSatePublisher.sink { [weak self] (state) in
            switch state {
            case .start, .finish:
                self?.updateUserPhoto()
                self?.fetchFavoriteVocabulary()
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
        userImage.value = SFSymbols.personCircle()
    }
    
    private func fetchFavoriteVocabulary() {
        guard let userId = userSession.currentUser?.id else {
            favoriteVocabularies = .empty
            return
        }
        
        let request = FavoriteVocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            self.favoriteVocabularies = vocabularies
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    // MARK: - Table View Configuration
    
    private func appendEmptySection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func appendMyWorkSection() {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Materials".localize,
                                      image: SFSymbols.meterials(),
                                      color: .systemGreen,
                                      accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Statistic".localize,
                                      image: SFSymbols.statistic(),
                                      color: .systemBlue,
                                      accessoryType: .disclosureIndicator)
        ]
        let headerViewModel = TitleSectionViewModel(text: "My Work".localize)
        let sectionViewModel = TableSectionViewModel(headerView: headerViewModel,
                                                     footerView: nil,
                                                     cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func appendFavoriteVocabularySection() {
        let headerViewModel = TitleSectionViewModel(text: "Favorites".localize,
                                                    buttonText: "Edit".localize,
                                                    buttonHandler: { [weak self] in self?.editFavoriteVocabularySection() })
        let sectionViewModel = TableSectionViewModel(headerView: headerViewModel,
                                                     footerView: nil,
                                                     cells: [ActivityIndicatorCellViewModel()])
        tableSections.append(sectionViewModel)
    }
    
    private func setupEmptyFavoriteVocabularySection() {
        let cellViewModels = [
            MessageCellViewModel(message: "Add favorite sets here to have quick access at any time, without having to search".localize)
        ]
        tableSections[SectionType.favorites.rawValue].cells.value = cellViewModels
    }
    
    private func setupFavoriteVocabularySection() {
        let cellViewModels = favoriteVocabularies.map({
            FavoriteVocabularyCellViewModel(vocabulary: $0)
        })
        tableSections[SectionType.favorites.rawValue].cells.value = cellViewModels
    }
    
    private func editFavoriteVocabularySection() {
        router.navigateToVocabularyList(addVocabularyHandler: { (vocabulary) in
            self.favoriteVocabularies.append(vocabulary)
        }) { (vocabularyForRemove) in
            self.favoriteVocabularies.removeAll(where: { $0 == vocabularyForRemove })
        }
    }
    
}
