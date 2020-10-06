//
//  UIEdgeInsets+Init.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    init(equal value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
}
