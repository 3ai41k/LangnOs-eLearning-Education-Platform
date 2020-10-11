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
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            contentView.setShadow(color: .black, opacity: 0.25)
        }
    }
    
    // MARK: - Public properties
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }

}
