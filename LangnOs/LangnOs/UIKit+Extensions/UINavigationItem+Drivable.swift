//
//  UINavigationItem+Drivable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UINavigationItem: DrivableViewProtocol {
    
    func drive(model: DrivableModelProtocol?) {
        drive(model: model as? NavigationItemDrivableModel)
    }
    
    private func drive(model: NavigationItemDrivableModel?) {
        guard let model = model else { return }
        
        self.title = model.title
    }
    
}
