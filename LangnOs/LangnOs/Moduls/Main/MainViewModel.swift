//
//  MainViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol NavigatableViewModelProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol { get }
}

protocol MainViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

protocol MainViewModelOutputProtocol {
    func fetchData()
}

final class MainViewModel: UniversalCollectionViewViewModel {
    
    // MARK: - Public properties
    
    var tableSections: [CollectionSectionViewModelProtocol]
    
    // MARK: - Private properties
    
    private let router: MainCoordinatorProtocol
    private let userInfo: UserInfoProtocol
    private let authorizator: LoginableProtocol
    private let dataFacade: DataFacadeFetchingProtocol
    private var vocabularies: [Vocabulary] {
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
         userInfo: UserInfoProtocol,
         authorizator: LoginableProtocol,
         dataFacade: DataFacadeFetchingProtocol) {
        self.router = router
        self.userInfo = userInfo
        self.authorizator = authorizator
        self.dataFacade = dataFacade
        self.vocabularies = []
        self.tableSections = []
        
        setupVocabularySection(&tableSections)
    }
    
    // MARK: - Public methods
    // UniversalCollectionViewViewModel
    
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
    
    private func setupVocabularySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        // FIX IT - Retain cycle. [weak self]
        let sectionViewModel = SearchBarCollectionReusableViewModel(textDidChange: searchVocabularyByName,
                                                                    didFiter: didFilterTouched,
                                                                    didCancle: didCancelTouched)
        tableSections.append(UniversalCollectionSectionViewModel(sectionViewModel: sectionViewModel, cells: []))
    }
    
    // MARK: - Action
    
    private func fetchData(completion: (() -> Void)?) {
        defer {
            completion?()
        }
        
        guard let userId = userInfo.userId else { return }
        
        let request = VocabularyFetchRequest(userId: userId)
        dataFacade.fetch(request: request) { (result: Result<[Vocabulary], Error>) in
            switch result {
            case .success(let vocabularies):
                self.vocabularies = vocabularies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func searchVocabularyByName(searchText: String) {
        let filteredVocabulary = vocabularies.filter({ $0.title.contains(searchText) })
        let cellViewModels = filteredVocabulary.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
    }
    
    private func didFilterTouched() {
        print(#function)
    }
    
    private func didCancelTouched() {
        let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
    }
    
    @objc
    private func didCreateNewVocabularyTouched() {
        if authorizator.isUserLogin {
            router.createNewVocabulary(didVocabularyCreateHandler: didVocabularyCreate)
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
    
    var navigationBarDrivableModel: DrivableModelProtocol {
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
