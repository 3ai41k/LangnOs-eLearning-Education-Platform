//
//  UIBarButtonItem+Init.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init?(model: DrivableModelProtocol) {
        guard let model = model as? BarButtonDrivableModel else { return nil }
        self.init(title: model.title, style: model.style, target: model.target, action: model.selector)
    }
    
}
