//
//  VocabularyCategoryCellFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

import UIKit

final class VocabularyCategoryCellFactory: UniversalTableViewCellFactoryProtocol {
    
    var cellTypes: [UniversalTableViewCellRegistratable.Type] {
        [
            TextTableViewCell.self
        ]
    }
    
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellViewModel {
        case let cellViewModel as TextCellViewModelProtocol:
            let cell = TextTableViewCell.dequeueReusableCell(tableView, for: indexPath)
            cell.viewModel = cellViewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
