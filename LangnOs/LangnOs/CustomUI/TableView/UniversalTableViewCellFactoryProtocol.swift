//
//  UniversalTableViewCellFactoryProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalTableViewCellFactoryProtocol {
    func registerAllCells(tableView: UITableView)
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
