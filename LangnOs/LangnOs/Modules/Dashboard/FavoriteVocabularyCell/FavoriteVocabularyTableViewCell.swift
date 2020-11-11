//
//  FavoriteVocabularyTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class FavoriteVocabularyTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - Public properties
    
    var viewModel: FavoriteVocabularyCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        textLabel?.text = viewModel?.title
        detailTextLabel?.text = viewModel?.category
    }
    
}
