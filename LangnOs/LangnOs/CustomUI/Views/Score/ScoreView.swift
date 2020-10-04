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
    
    // MARK: - Private properties
    
    private var gradientLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 0.85, y: 0.0)
        layer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemPink.cgColor,
            UIColor.systemOrange.cgColor
        ]
        layer.locations = [
            0.1,
            0.5,
            0.75,
            1.0
        ]
        return layer
    }()
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.bounds
    }
    
}
