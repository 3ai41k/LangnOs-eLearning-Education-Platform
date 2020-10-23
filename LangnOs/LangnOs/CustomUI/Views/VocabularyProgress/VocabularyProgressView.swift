//
//  VocabularyProgressView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class VocabularyProgressView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var phrasesLearnedLabel: UILabel!
    @IBOutlet private weak var phrasesLeftToLearnLabel: UILabel!
    @IBOutlet private weak var totalLearningTimeLabel: UILabel!
    
    // MARK: - Public properties
    
    var phrasesLearned: Int = 0 {
        didSet {
            phrasesLearnedLabel.text = String(phrasesLearned)
        }
    }
    
    var phrasesLeftToLearn: Int = 0 {
        didSet {
            phrasesLeftToLearnLabel.text = String(phrasesLeftToLearn)
        }
    }
    
    var totalLearningTime: Double = .zero {
        didSet {
            totalLearningTimeLabel.text = "\(totalLearningTime)h"
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCornerRadius()
        setupBorders()
    }
    
    // MARK: - Private methods
    
    private func setupCornerRadius() {
        layer.cornerRadius = 10.0
    }
    
    private func setupBorders() {
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 0.25
    }

}
