//
//  ListViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ListViewModelInputProtocol {
    
}

protocol ListViewModelOutputProtocol {
    
}

typealias ListViewModelProtocol =
    ListViewModelInputProtocol &
    ListViewModelOutputProtocol &
    UniversalTableViewModelProtocol

final class ListViewController<ViewModel: ListViewModelProtocol>: BindibleViewController<ViewModel> {

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
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions

}
