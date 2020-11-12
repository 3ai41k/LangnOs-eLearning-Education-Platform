//
//  MaintenanceViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol MaintenanceViewModelInputProtocol {
    
}

protocol MaintenanceViewModelOutputProtocol {
    func synchronize()
    func close()
}

protocol MaintenanceViewModelBindingProtocol {
    var hideSynchronizeView: (() -> Void)? { get set }
}

typealias MaintenanceViewModelProtocol =
    MaintenanceViewModelInputProtocol &
    MaintenanceViewModelOutputProtocol &
    MaintenanceViewModelBindingProtocol

final class MaintenanceViewModel: MaintenanceViewModelProtocol {
    
    // MARK: - Public properties
    
    var hideSynchronizeView: (() -> Void)?
    
    // MARK: - Private properties
    
    private let router: MaintenanceCoordinatorProtocol
    private let dataSynchronizer: CloudSynchronizeProtocol
    
    // MARK: - Init
    
    init(router: MaintenanceCoordinatorProtocol,
         dataSynchronizer: CloudSynchronizeProtocol) {
        self.router = router
        self.dataSynchronizer = dataSynchronizer
    }
    
    // MARK: - Public methods
    
    func synchronize() {
        dataSynchronizer.synchronize(completion: hideSynchronizeView)
    }
    
    func close() {
        router.close()
    }
}


