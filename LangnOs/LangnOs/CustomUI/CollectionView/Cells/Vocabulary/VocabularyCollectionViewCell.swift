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
            containerView.layer.cornerRadius = 20.0
        }
    }
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phrasesLearnnedView: UIView! {
        didSet {
            phrasesLearnnedView.layer.cornerRadius = phrasesLearnnedView.bounds.height / 2.0
        }
    }
    @IBOutlet private weak var phrasesLearnedLabel: UILabel!
    @IBOutlet private weak var phrasesLeftToLearnView: UIView! {
        didSet {
            phrasesLeftToLearnView.layer.cornerRadius = phrasesLeftToLearnView.bounds.height / 2.0
        }
    }
    @IBOutlet private weak var phrasesLeftToLearnLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 20.0
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: VocabularyCollectionViewCellInputProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setShadow(color: .black, opacity: 0.25)
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        categoryLabel.text = viewModel?.category
        nameLabel.text = viewModel?.title
        phrasesLearnedLabel.text = viewModel?.phrasesLeftToLearn
        phrasesLeftToLearnLabel.text = viewModel?.phrasesLeftToLearn
        
        setupColor()
    }
    
    private func setupColor() {
        containerView.backgroundColor = viewModel?.color
        phrasesLearnnedView.backgroundColor = viewModel?.color
        phrasesLeftToLearnView.backgroundColor = viewModel?.color
    }
    
}
