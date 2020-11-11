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
        title = viewModel?.title
        vocabularyProgressView.phrasesLearned = viewModel?.phrasesLearned ?? 0
        vocabularyProgressView.phrasesLeftToLearn = viewModel?.phrasesLeftToLearn ?? 0
        vocabularyProgressView.totalLearningTime = viewModel?.totalLearningTime ?? 0
    }
    
    override func setupUI() {
        let moreButton = UIBarButtonItem(image: SFSymbols.more(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didMoreButtonTouch))
        
        navigationItem.rightBarButtonItem = moreButton
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didFlashCardsTouch(_ sender: Any) {
        viewModel?.flashCardsAction()
    }
    
    @IBAction
    private func didWritingTouch(_ sender: Any) {
        viewModel?.writingAction()
    }
    
    @IBAction
    private func didShowWordsTouch(_ sender: Any) {
        viewModel?.wordsAction()
    }
    
    @objc
    private func didMoreButtonTouch() {
        viewModel?.settingsAction()
    }
    
}
