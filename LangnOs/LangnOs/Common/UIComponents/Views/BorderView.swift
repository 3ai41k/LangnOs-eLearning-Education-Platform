//
//  BorderView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 15.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class BorderView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
}
