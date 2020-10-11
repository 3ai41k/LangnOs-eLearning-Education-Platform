//
//  TopBarView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 11.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class TopBarView: XibView {
    
    // MARK: - Public properties
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setShadow(color: .black, opacity: 0.25)
    }

}
