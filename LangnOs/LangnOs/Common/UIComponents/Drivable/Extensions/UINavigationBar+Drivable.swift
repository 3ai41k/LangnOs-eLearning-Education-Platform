//
//  UINavigationBar+Drivable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UINavigationBar: DrivableViewProtocol {
    
    func drive(model: DrivableModelProtocol?) {
        drive(model: model as? NavigationBarDrivableModel)
    }
    
    private func drive(model: NavigationBarDrivableModel?) {
        guard let model = model else { return }
        
        if model.isBottomLineHidden {
            self.shadowImage = UIImage()
        }
        
        self.barTintColor = model.backgroundColor
        self.prefersLargeTitles = model.prefersLargeTitles
    }
    
}
