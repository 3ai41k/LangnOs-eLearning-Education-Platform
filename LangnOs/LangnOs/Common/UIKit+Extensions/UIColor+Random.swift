//
//  UIColor+Random.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIColor {
    
    static private var colors: [UIColor] {
        [
            UIColor.systemPink,
            UIColor.systemPurple,
            UIColor.systemYellow,
            UIColor.systemBlue,
            UIColor.systemOrange
        ]
    }
    
    static var random: UIColor {
        let randomIndex = Int.random(in: 0..<colors.count)
        return colors[randomIndex]
    }
    
}
