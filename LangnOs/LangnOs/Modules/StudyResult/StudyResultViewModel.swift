//
//  StudyResultViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 20.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol StudyResultViewModelInputProtocol {
    
}

enum StudyResultViewModelAction {
    case close
}

protocol StudyResultViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<StudyResultViewModelAction, Never> { get }
}

protocol StudyResultViewModelBindingProtocol {
    
}

typealias StudyResultViewModelProtocol =
    StudyResultViewModelInputProtocol &
    StudyResultViewModelOutputProtocol &
    StudyResultViewModelBindingProtocol

final class StudyResultViewModel: StudyResultViewModelProtocol {
    
    // MARK: - Public properties
    
    var actionSubject = PassthroughSubject<StudyResultViewModelAction, Never>()
    
    // MARK: - Private properties
    
    private let router: StudyResultCoordinatorProtocol
    
    private var actionPublisher: AnyPublisher<StudyResultViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(router: StudyResultCoordinatorProtocol) {
        self.router = router
        
        self.bindView()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
            actionPublisher.sink(receiveValue: { [weak self] action in
                switch action {
                case .close:
                    self?.router.close()
                }
            })
        ]
    }
    
}


