//
//  MainViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MainViewController: BindibleViewController<MainViewModelInputProtocol & MainViewModelOutputProtocol> {

    // MARK: - IBOutlets
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponents()
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Private methods
    
    private func initializeComponents() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }

}
