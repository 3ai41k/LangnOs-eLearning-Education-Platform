//
//  VocabularyViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyViewController: BindibleViewController<VocabularyViewModelInputProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var topBarView: UIView! {
        didSet {
            topBarView.layer.cornerRadius = 10.0
            topBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBOutlet private weak var vocabularyNameLabel: UILabel!
    @IBOutlet private weak var numberOfCardsLabel: UILabel!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    
    // MARK: - Public properties
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Public methods
    // MARK: - Private methods
    
    // MARK: - Override
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    override func configurateComponents() {
        vocabularyNameLabel.text = viewModel?.vocabularyName
        numberOfCardsLabel.text = viewModel?.numberOfWords
        categoryNameLabel.text = viewModel?.category
    }
    
    // MARK: - Actions
    
    
    
}
