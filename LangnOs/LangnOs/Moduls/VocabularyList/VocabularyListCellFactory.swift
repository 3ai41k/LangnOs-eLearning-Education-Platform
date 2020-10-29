//
//  VocabularyListCellFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyListCellFactory: UniversalTableViewCellFactoryProtocol {
    
    var cellTypes: [UniversalTableViewCellRegistratable.Type] {
        [
            AddToFavoriteTableViewCell.self
        ]
    }
    
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellViewModel {
        case let cellViewModel as AddToFavoriteCellViewModelProtocol:
            let cell = AddToFavoriteTableViewCell.dequeueReusableCell(tableView, for: indexPath)
            cell.viewModel = cellViewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
