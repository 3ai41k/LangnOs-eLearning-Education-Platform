//
//  BindibleViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol DrivableNavigationItemProtocol {
    var navigationItemDrivableModel: CurrentValueSubject<DrivableModelProtocol, Never> { get }
}

class BindibleViewController<ViewModel>: UIViewController {
    
    // MARK: - Protected(internal) methods
    
    internal var viewModel: ViewModel?
    internal var cancellables: [AnyCancellable?] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configurateComponents()
        setupUI()
    }
    
    // MARK: - Protected(internal) methods
    
    internal func bindViewModel() {
//        if let viewModel = ViewModel.self as? DrivableNavigationItemProtocol {
//            viewModel.navigationItemDrivableModel.sink { [weak self] (model) in
//                self?.navigationItem.drive(model: model)
//            }.store(in: &cancellables)
//        }
    }
    
    internal func configurateComponents() { }
    
    internal func setupUI() { }
    
}
