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
            tableView.backgroundView = backgroundView
            tableView.tableFooterView = UIView()
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private properties
    
    private let backgroundView = NoResulsView()
    
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
        backgroundView.title = viewModel?.backgroudTitle
    }
    
}

