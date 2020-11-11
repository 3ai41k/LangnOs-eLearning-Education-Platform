//
//  UniversalTableViewCellFactoryProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalTableViewCellFactoryProtocol: class {
    var cellTypes: [UniversalTableViewCellRegistratable.Type] { get }
    func registerAllCells(tableView: UITableView)
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

extension UniversalTableViewCellFactoryProtocol {
    
    func registerAllCells(tableView: UITableView) {
        cellTypes.forEach({ $0.register(tableView) })
    }
    
}
