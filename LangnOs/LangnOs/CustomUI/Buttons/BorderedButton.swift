//
//  BorderedButton.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class BorderedButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
}
