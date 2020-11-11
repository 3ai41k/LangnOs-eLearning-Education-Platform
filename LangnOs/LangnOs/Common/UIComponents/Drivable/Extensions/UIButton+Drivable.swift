//
//  UIButton+Drivable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIButton: DrivableViewProtocol {
    
    func drive(model: DrivableModelProtocol?) {
        drive(model: model as? ButtonDrivableModel)
    }
    
    private func drive(model: ButtonDrivableModel?) {
        guard let model = model else { return }
        
        setTitle(model.title, for: .normal)
        setTitleColor(model.titleColor, for: .normal)
        addTarget(model.target, action: model.selector, for: .touchUpInside)
    }
    
}
