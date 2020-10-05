//
//  UniversalTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

typealias UniversalTableViewViewModel = UniversalTableViewInputProtocol & UniversalTableViewBindingProtocol

final class UniversalTableView: UITableView {
    
    // MARK: - Private properties
    
    private var viewModel: UniversalTableViewViewModel! {
        didSet {
            viewModel.reloadData = { [weak self] in
                self?.reloadData()
            }
        }
    }
    private var cellFactory: UniversalTableViewCellFactoryProtocol! {
        didSet {
            cellFactory.registerAllCells(tableView: self)
        }
    }
    
    // MARK: - Public methods
    
    func start(viewModel: UniversalTableViewViewModel, cellFactory: UniversalTableViewCellFactoryProtocol) {
        self.viewModel = viewModel
        self.cellFactory = cellFactory
        
        dataSource = self
        
        reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension UniversalTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModelForRowAt(indexPath: indexPath)
        return cellFactory.generateCell(cellViewModel: cellViewModel, tableView: tableView, indexPath: indexPath)
    }
    
}


