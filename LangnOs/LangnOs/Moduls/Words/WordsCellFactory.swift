//
//  WordsCellFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class WordsCellFactory: UniversalTableViewCellFactoryProtocol {
    
    private var cellTypes: [UniversalTableViewCellRegistratable.Type] {
        [
            WordTableViewCell.self
        ]
    }
    
    func registerAllCells(tableView: UITableView) {
        cellTypes.forEach({ $0.register(tableView) })
    }
    
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellViewModel {
        case let cellViewModel as WordTableViewCellViewModel:
            let cell = WordTableViewCell.dequeueReusableCell(tableView, for: indexPath)
            cell.viewModel = cellViewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
