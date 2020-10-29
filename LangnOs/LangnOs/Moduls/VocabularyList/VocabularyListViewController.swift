//
//  VocabularyListViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyListViewController: BindibleViewController<VocabularyListViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    
    // MARK: - Private properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.fetchData()
    }
    
    // MARK: - Init
    
    
    
    
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
    }
    
    override func setupUI() {
        
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    
    
    
    
    // MARK: - Private methods
    
    
    
    // MARK: - Actions
    
}

