//
//  VocabularyCollectionViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyCollectionViewCell: UICollectionViewCell, UniversalCollectionViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberOfWordsLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: VocabularyCollectionViewCellInputProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        titleLabel.text = viewModel?.title
        numberOfWordsLabel.text = viewModel?.numberOfWords
    }
    
}
