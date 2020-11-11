//
//  UIView+Shadow.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIView {
    
    func setShadow(color: UIColor, opacity: Float) {
        setShadow(color: color,
                  offset: CGSize(width: 1.0, height: 1.0),
                  opacity: opacity)
    }
    
    func setShadow(color: UIColor, offset: CGSize, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
}
