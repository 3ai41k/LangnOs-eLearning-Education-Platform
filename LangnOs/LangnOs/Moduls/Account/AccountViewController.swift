//
//  AccountViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class AccountViewController: BindibleViewController<AccountInputProtocol & AccountOutputProtocol & AccountBindingProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            
        }
    }
    
    // MARK: - Public properties
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    
    override func bindViewModel() {
        viewModel?.reloadUI = { [weak self] in
            self?.setupUI()
        }
    }
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions

}
