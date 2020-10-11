//
//  VocabularyViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyViewController: BindibleViewController<VocabularyViewModelInputProtocol & VocabularyViewModelOutputProtocol> {

    // MARK: - IBOutlets
    
    // Refactore it
    @IBOutlet private weak var topBarView: UIView! {
        didSet {
            topBarView.layer.cornerRadius = 20.0
            topBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            topBarView.setShadow(color: .black, opacity: 0.25)
        }
    }
    @IBOutlet private weak var vocabularyNameLabel: UILabel!
    @IBOutlet private weak var numberOfCardsLabel: UILabel!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var vocabularyProgressView: VocabularyProgressView!
    
    // MARK: - Override
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    override func configurateComponents() {
        guard let viewModel = viewModel else { return }
        
        vocabularyNameLabel.text = viewModel.vocabularyName
        numberOfCardsLabel.text = viewModel.numberOfWords
        categoryNameLabel.text = viewModel.category
        
        vocabularyProgressView.phrasesLearned = viewModel.phrasesLearned
        vocabularyProgressView.phrasesLeftToLearn = viewModel.phrasesLeftToLearn
        vocabularyProgressView.totalLearningTime = viewModel.totalLearningTime
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didFlashCardsTouch(_ sender: Any) {
        viewModel?.showFlashCardsAction()
    }
    
    @IBAction
    private func didShowWordsTouch(_ sender: Any) {
        viewModel?.showWordsAction()
    }
    
}
