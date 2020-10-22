//
//  DashboardViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import FirebaseAuth
import Combine

protocol NavigatableViewModelProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol? { get }
}

extension NavigatableViewModelProtocol {
    var navigationBarDrivableModel: DrivableModelProtocol? { nil }
}

protocol DashboardViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

protocol DashboardViewModelOutputProtocol {
    func fetchData()
}

typealias DashboardViewModelProtocol =
    DashboardViewModelInputProtocol &
    DashboardViewModelOutputProtocol &
    UniversalCollectionViewViewModel

final class DashboardViewModel: UniversalCollectionViewViewModel {
    
    // MARK: - Public properties
    
    var tableSections: [CollectionSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: DashboardCoordinatorProtocol
    private let contex: UserSessesionPublisherContextProtocol & CentreButtonTabBarPublisherContrxtProtocol
    private let securityManager: SecurityManager
    private let dataFacade: DataFacadeFetchingProtocol
    
    private var cancellables: [AnyCancellable?] = []
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            tableSections[SectionType.vocabulary.rawValue].cells = vocabularies.map({
                VocabularyCollectionViewCellViewModel(vocabulary: $0)
            })
        }
    }
    private var vocabularyFilter: VocabularyFilter = .name
    
    private enum SectionType: Int {
        case vocabulary
    }
    
    // MARK: - Init
    
    init(router: DashboardCoordinatorProtocol,
         contex: UserSessesionPublisherContextProtocol & CentreButtonTabBarPublisherContrxtProtocol,
         securityManager: SecurityManager,
         dataFacade: DataFacadeFetchingProtocol) {
        self.router = router
        self.contex = contex
        self.securityManager = securityManager
        self.dataFacade = dataFacade
        
        self.bindContext()
        
        self.setupVocabularySection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabularyStatistic(vocabulary) {
            self.vocabularies.remove(at: indexPath.row)
        }
    }
    
    func refreshData(completion: @escaping () -> Void) {
        fetchData {
            completion()
        }
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        cancellables = [
            contex.userSessionPublisher.sink { [weak self] _ in
                self?.fetchData()
            },
            contex.centreButtonPublisher.sink { [weak self] in
                self?.createNewVocabulary()
            }
        ]
    }
    
    private func setupVocabularySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        // FIX IT - Retain cycle. [weak self]
        let sectionHeaderViewModel = SearchBarCollectionReusableViewModel(textDidChange: searchVocabulary,
                                                                          didFiter: didFilterTouched,
                                                                          didCancle: didCancelTouched)
        //let sectionFooterViewModel = ViewAllCollectionReusableViewModel()
        tableSections.append(UniversalCollectionSectionViewModel(sectionHeaderViewModel: sectionHeaderViewModel,
                                                                 sectionFooterViewModel: nil,
                                                                 cells: []))
    }
    
    private func searchVocabulary(searchText: String) {
        
    }
    
    private func fetchData(completion: (() -> Void)?) {
        defer {
            completion?()
        }
        
        if let userId = securityManager.user?.uid {
            let request = VocabularyFetchRequest(userId: userId)
            dataFacade.fetch(request: request) { (result: Result<[Vocabulary], Error>) in
                switch result {
                case .success(let vocabularies):
                    self.vocabularies = vocabularies
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            // TO DO: Remove from the device
            self.vocabularies = []
        }
    }
    
    private func createNewVocabulary() {
        if let user = securityManager.user {
            router.createNewVocabulary(user: user, didVocabularyCreateHandler: didVocabularyCreate)
        } else {
            let canelAlertAction = CancelAlertAction(handler: { })
            let singInAlertAction = SingInAlertAction(handler: didSingInTouched)
            router.showAlert(title: "Attention!".localize,
                             message: "You are not authrized!".localize,
                             actions: [canelAlertAction, singInAlertAction])
        }
    }
    
    // MARK: - Action
    
    private func didFilterTouched() {
        router.navigateToFilter(selectedFilter: vocabularyFilter) { vocabularyFilter in
            self.vocabularyFilter = vocabularyFilter
        }
    }
    
    private func didCancelTouched() {
        let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
    }
    
    private func didVocabularyCreate(_ vocabulary: Vocabulary) {
        vocabularies.append(vocabulary)
    }
    
    private func didSingInTouched() {
        router.navigateToSingIn()
    }
    
}

// MARK: - DashboardViewModelInputProtocol

extension DashboardViewModel: DashboardViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        return NavigationItemDrivableModel(title: "Materials".localize,
                                           leftBarButtonDrivableModels: [],
                                           rightBarButtonDrivableModels: [])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol? {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .systemBackground,
                                   prefersLargeTitles: false)
    }
    
}

// MARK: - DashboardViewModelOutputProtocol

extension DashboardViewModel: DashboardViewModelOutputProtocol {
    
    func fetchData() {
        fetchData(completion: nil)
    }
    
}
