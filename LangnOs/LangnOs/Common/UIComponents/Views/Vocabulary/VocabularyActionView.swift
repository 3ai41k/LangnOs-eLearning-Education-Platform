//
//  VocabularyActionView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class VocabularyActionView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBorders()
    }
    
    // MARK: - Public properties
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Private methods
    
    private func setupBorders() {
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 0.25
    }
    
}
