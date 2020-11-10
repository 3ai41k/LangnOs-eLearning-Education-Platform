//
//  SeachVocabularyCellFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 10.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class SeachVocabularyCellFactory: UniversalTableViewCellFactoryProtocol {
    
    var cellTypes: [UniversalTableViewCellRegistratable.Type] {
        [
            SearchVocabularyTableViewCell.self
        ]
    }
    
    func generateCell(cellViewModel: CellViewModelProtocol, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellViewModel {
        case let cellViewModel as SearchVocabularyCellProtocol:
            let cell = SearchVocabularyTableViewCell.dequeueReusableCell(tableView, for: indexPath)
            cell.viewModel = cellViewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
