//
//  MainViewModel.swift
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

protocol MainViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

protocol MainViewModelOutputProtocol {
    func fetchData()
}

final class MainViewModel: UniversalCollectionViewViewModel {
    
    // MARK: - Public properties
    
    var tableSections: [CollectionSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: MainCoordinatorProtocol
    private let contex: UserSessesionPublisherContextProtocol
    private let securityManager: SecurityManager
    
    private var cancellables: [AnyCancellable] = []
    
    private let coreDataContext: ContextAccessableProtocol
    private let dataFacade: DataFacadeFetchingProtocol
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            tableSections[SectionType.vocabulary.rawValue].cells = vocabularies.map({
                VocabularyCollectionViewCellViewModel(vocabulary: $0)
            })
        }
    }
    
    private enum SectionType: Int {
        case vocabulary
    }
    
    // MARK: - Init
    
    init(router: MainCoordinatorProtocol,
         contex: UserSessesionPublisherContextProtocol,
         securityManager: SecurityManager,
         coreDataContext: ContextAccessableProtocol,
         dataFacade: DataFacadeFetchingProtocol) {
        self.router = router
        self.contex = contex
        self.securityManager = securityManager
        self.coreDataContext = coreDataContext
        self.dataFacade = dataFacade
        
        bindContext()
        
        setupVocabularySection(&tableSections)
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
        contex.userSessionPublisher.sink { [weak self] _ in
            self?.fetchData()
        }.store(in: &cancellables)
    }
    
    private func setupVocabularySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        // FIX IT - Retain cycle. [weak self]
        let sectionViewModel = SearchBarCollectionReusableViewModel(textDidChange: searchVocabulary,
                                                                    didFiter: didFilterTouched,
                                                                    didCancle: didCancelTouched)
        tableSections.append(UniversalCollectionSectionViewModel(sectionViewModel: sectionViewModel, cells: []))
    }
    
    // MARK: - Action
    
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
    
    private func searchVocabulary(searchText: String) {
//        do {
//            let filteredVocabulary = try Vocabulary.select(context: coreDataContext.context, query: query)
//            let cellViewModels = filteredVocabulary.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
//            tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
//        } catch {
//            router.showAlert(title: "Error!", message: error.localizedDescription, actions: [
//                OkAlertAction(handler: { })
//            ])
//        }
    }
    
    private func didFilterTouched() {
        
    }
    
    private func didCancelTouched() {
        let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
    }
    
    @objc
    private func didCreateNewVocabularyTouched() {
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
    
    private func didVocabularyCreate(_ vocabulary: Vocabulary) {
        vocabularies.append(vocabulary)
    }
    
    private func didSingInTouched() {
        router.navigateToSingIn()
    }
    
}

// MARK: - MainViewModelInputProtocol

extension MainViewModel: MainViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let createNewVocabularyButtonModel = BarButtonDrivableModel(title: "Create".localize,
                                                                    style: .plain,
                                                                    target: self,
                                                                    selector: #selector(didCreateNewVocabularyTouched))
        return NavigationItemDrivableModel(title: "Maerials".localize,
                                           leftBarButtonDrivableModels: [],
                                           rightBarButtonDrivableModels: [createNewVocabularyButtonModel])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol? {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .systemBackground,
                                   prefersLargeTitles: false)
    }
    
}

// MARK: - MainViewModelOutputProtocol

extension MainViewModel: MainViewModelOutputProtocol {
    
    func fetchData() {
        fetchData(completion: nil)
    }
    
}
