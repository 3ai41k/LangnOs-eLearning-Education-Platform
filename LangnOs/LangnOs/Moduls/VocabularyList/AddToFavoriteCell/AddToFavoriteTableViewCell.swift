//
//  AddToFavoriteTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class AddToFavoriteTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var totalWordsLabel: UILabel!
    @IBOutlet private weak var heartButton: UIButton!
    
    // MARK: - Public properties
    
    var viewModel: AddToFavoriteCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func bindViewModel() {
        nameLabel.text = viewModel?.name
        categoryLabel.text = viewModel?.category
        totalWordsLabel.text = viewModel?.totalWords
        viewModel?.isFavorite.sink(receiveValue: { [weak self] (isFavorite) in
            let image = isFavorite ? SFSymbols.heart(for: .fill) : SFSymbols.heart(for: .normal)
            self?.heartButton.setImage(image, for: .normal)
        }).store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didHeartButtonTouch(_ sender: UIButton) {
        viewModel?.favoriteAction()
    }
    
}
