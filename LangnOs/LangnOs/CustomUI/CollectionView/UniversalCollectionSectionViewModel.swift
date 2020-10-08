//
//  UniversalCollectionSectionViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

final class UniversalCollectionSectionViewModel: CollectionSectionViewModelProtocol {
    
    // MARK: - Private properties
    
    private var reloadSubject: PassthroughSubject<Void, Never>
    
    // MARK: - Public properties
    
    var sectionViewModel: CollectionReusableViewModelProtocol?
    var cells: [CellViewModelProtocol] {
        didSet {
            reloadSubject.send()
        }
    }
    var reload: AnyPublisher<Void, Never> {
        reloadSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    init(sectionViewModel: CollectionReusableViewModelProtocol?, cells: [CellViewModelProtocol]) {
        self.sectionViewModel = sectionViewModel
        self.cells = cells
        self.reloadSubject = PassthroughSubject<Void, Never>()
    }
    
}
