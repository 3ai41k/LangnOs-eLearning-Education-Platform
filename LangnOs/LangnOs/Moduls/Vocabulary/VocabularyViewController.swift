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
    
    @IBOutlet private weak var vocabularyProgressView: VocabularyProgressView!
    
    // MARK: - Override
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        title = viewModel.title
        
        vocabularyProgressView.phrasesLearned = viewModel.phrasesLearned
        vocabularyProgressView.phrasesLeftToLearn = viewModel.phrasesLeftToLearn
        vocabularyProgressView.totalLearningTime = viewModel.totalLearningTime
    }
    
    override func setupUI() {
        let removeButton = UIBarButtonItem(image: SFSymbols.more(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(didMoreButtonTouch))
        
        navigationItem.rightBarButtonItem = removeButton
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didFlashCardsTouch(_ sender: Any) {
        viewModel?.actionSubject.send(.flashCards)
    }
    
    @IBAction
    private func didWritingTouch(_ sender: Any) {
        viewModel?.actionSubject.send(.writing)
    }
    
    @IBAction
    private func didShowWordsTouch(_ sender: Any) {
        viewModel?.actionSubject.send(.words)
    }
    
    @objc
    private func didMoreButtonTouch() {
        
    }
    
}
