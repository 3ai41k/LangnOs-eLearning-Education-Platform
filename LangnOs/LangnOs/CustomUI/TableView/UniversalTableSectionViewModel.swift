//
//  UniversalTableSectionViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

final class UniversalTableSectionViewModel: TableSectionViewModelProtocol {
    
    // MARK: - Private properties
    
    private var reloadSubject: PassthroughSubject<Void, Never>
    
    // MARK: - Public properties
    
    var title: String?
    var cells: [CellViewModelProtocol] {
        didSet {
            reloadSubject.send()
        }
    }
    var reload: AnyPublisher<Void, Never> {
        reloadSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    init(title: String?, cells: [CellViewModelProtocol]) {
        self.title = title
        self.cells = cells
        self.reloadSubject = PassthroughSubject<Void, Never>()
    }
    
}
