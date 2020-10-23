//
//  DashboardCellFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class DashboardCellFactory: UniversalTableViewCellFactoryProtocol {
    
    var cellTypes: [UniversalTableViewCellRegistratable.Type] {
        [
            FilterTableViewCell.self
        ]
    }
    
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellViewModel {
        case let cellViewModel as FilterTableViewCellViewModel:
            let cell = FilterTableViewCell.dequeueReusableCell(tableView, for: indexPath)
            cell.viewModel = cellViewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}