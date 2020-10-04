//
//  VocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyViewModelInputProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol { get }
    var vocabularyName: String { get }
    var numberOfWords: String { get }
    var category: String { get }
}

final class VocabularyViewModel {
    
    // MARK: - Private properties
    
    private let router: VocabularyNavigationProtocol
    private let vocabulary: Vocabulary
    
    // MARK: - Init
    
    init(router: VocabularyNavigationProtocol, vocabulary: Vocabulary) {
        self.router = router
        self.vocabulary = vocabulary
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
}

// MARK: - VocabularyViewModelInputProtocol

extension VocabularyViewModel: VocabularyViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let closeButtonModel = BarButtonDrivableModel(title: "Close".localize,
                                                      style: .plain,
                                                      target: self,
                                                      selector: #selector(didCloseTouched))
        return NavigationItemDrivableModel(title: nil,
                                           leftBarButtonDrivableModels: [closeButtonModel],
                                           rightBarButtonDrivableModels: [])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .white,
                                   prefersLargeTitles: false)
    }
    
    var vocabularyName: String {
        vocabulary.title
    }
    
    var numberOfWords: String {
        String(format: "%d %@", vocabulary.words.count, "cards".localize)
    }
    
    var category: String {
        "Career"
    }
    
}
