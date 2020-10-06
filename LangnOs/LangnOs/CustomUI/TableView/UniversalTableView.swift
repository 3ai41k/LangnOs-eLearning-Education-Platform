//
//  UniversalTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

typealias UniversalTableViewViewModel = UniversalTableViewSectionProtocol

protocol TableSectionViewModelProtocol: class {
    var title: String? { get }
    var cells: [CellViewModelProtocol] { get set }
    var reload: AnyPublisher<Void, Never> { get }
}

protocol TableSectionViewModelDataSourceProtocol {
    var rowsCount: Int { get }
    func cellViewModelFor(rowAt index: Int) -> CellViewModelProtocol
}

protocol UniversalTableViewSectionProtocol {
    var tableSections: [TableSectionViewModelProtocol] { get }
}

final class UniversalTableView: UITableView {
    
    // MARK: - Private properties
    
    private var cancellable: [AnyCancellable] = []
    
    private var viewModel: UniversalTableViewViewModel! {
        didSet {
            viewModel.tableSections.enumerated().forEach({ (index, section) in
                section.reload.sink(receiveValue: { [weak self] in
                    self?.reloadSections([index], with: .automatic)
                }).store(in: &cancellable)
            })
        }
    }
    private var cellFactory: UniversalTableViewCellFactoryProtocol! {
        didSet {
            cellFactory.registerAllCells(tableView: self)
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTapGusture()
    }
    
    // MARK: - Public methods
    
    func start(viewModel: UniversalTableViewViewModel, cellFactory: UniversalTableViewCellFactoryProtocol) {
        self.viewModel = viewModel
        self.cellFactory = cellFactory
        
        dataSource = self
        
        reloadData()
    }
    
    // MARK: - Private methods
    
    private func addTapGusture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapOnView() {
        endEditing(true)
    }
    
}

// MARK: - UITableViewDataSource

extension UniversalTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableSections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.tableSections[indexPath.section].cells[indexPath.row]
        return cellFactory.generateCell(cellViewModel: cellViewModel, tableView: tableView, indexPath: indexPath)
    }
    
}


