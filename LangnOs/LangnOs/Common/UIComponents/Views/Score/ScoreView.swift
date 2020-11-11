//
//  ScoreView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class ScoreView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var keepImprovingLabel: UILabel!
    @IBOutlet private weak var currentScoreLabel: UILabel!
    
    // MARK: - Public properties
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBorders()
    }
    
    // MARK: - Private methods
    
    private func setupBorders() {
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 0.25
    }
    
}
