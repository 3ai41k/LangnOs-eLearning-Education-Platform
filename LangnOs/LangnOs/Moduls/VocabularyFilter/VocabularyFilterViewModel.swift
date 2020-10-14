//
//  VocabularyFilterViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyFilterViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

protocol VocabularyFilterViewModelOutputProtocol {
    func fetchData()
}

protocol VocabularyFilterViewModelBindingProtocol {
    var updateUI: (() -> Void)? { get set }
}

typealias VocabularyFilterViewModelProtocol =
    VocabularyFilterViewModelInputProtocol &
    VocabularyFilterViewModelOutputProtocol &
    VocabularyFilterViewModelBindingProtocol &
    UniversalTableViewModelProtocol

final class VocabularyFilterViewModel: VocabularyFilterViewModelBindingProtocol, UniversalTableViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [UniversalTableSectionViewModelProtocol] = []
    var updateUI: (() -> Void)?
    
    // MARK: - Private properties
    
    private var vocabularyFilters: [VocabularyFilter] = [] {
        didSet {
            self.tableSections[SectionType.filter.rawValue].cells = vocabularyFilters.map({
                FilterTableViewCellViewModel(vocabularyFilter: $0)
            })
        }
    }
    private var selectedVocabularyFilter: VocabularyFilter?
    
    private enum SectionType: Int {
        case filter
    }
    
    private let router: VocabularyFilterCoordinatorProtocol
    private let dataFacade: DataFacadeFetchingProtocol
    
    // MARK: - Init
    
    init(router: VocabularyFilterCoordinatorProtocol,
         dataFacade: DataFacadeFetchingProtocol,
         selectedVocabularyFilter: VocabularyFilter?) {
        self.router = router
        self.dataFacade = dataFacade
        self.selectedVocabularyFilter = selectedVocabularyFilter
        
        setupFilterSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        selectedVocabularyFilter = vocabularyFilters[indexPath.row]
        updateUI?()
    }
    
    // MARK: - Private methods
    
    private func setupFilterSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        tableSections.append(UniversalTableSectionViewModel(cells: []))
    }
    
    // MARK: - Actions
    
    @objc
    private func didDoneTouch() {
        guard let vocabularyFilter = selectedVocabularyFilter else { return }
        router.selectVocabularyFilter(vocabularyFilter)
    }
    
}

// MARK: - VocabularyFilterViewModelInputProtocol

extension VocabularyFilterViewModel: VocabularyFilterViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let doneBarButtonDrivableModel = BarButtonDrivableModel(title: "Done".localize,
                                                                style: .done,
                                                                target: self,
                                                                selector: #selector(didDoneTouch))
        let rightBarButtonDrivableModels = selectedVocabularyFilter != nil ? [doneBarButtonDrivableModel] : []
        return NavigationItemDrivableModel(title: "Filter".localize,
                                    leftBarButtonDrivableModels: [],
                                    rightBarButtonDrivableModels: rightBarButtonDrivableModels)
    }
    
}

// MARK: - VocabularyFilterViewModelOutputProtocol

extension VocabularyFilterViewModel: VocabularyFilterViewModelOutputProtocol {
    
    func fetchData() {
        router.showActivity()
        
        let request = VocabularyFilterFetchRequest()
        dataFacade.fetch(request: request) { (result: Result<[VocabularyFilter], Error>) in
            self.router.closeActivity()
            
            switch result {
            case .success(let vocabularyFilters):
                self.vocabularyFilters = vocabularyFilters
            case .failure(let error):
                self.router.showAlert(title: "Error!".localize, message: error.localizedDescription, actions: [
                    OkAlertAction(handler: { })
                ])
            }
        }
    }
    
}


