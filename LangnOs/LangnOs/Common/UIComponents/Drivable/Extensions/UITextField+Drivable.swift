//
//  UITextField+Drivable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UITextField: DrivableViewProtocol {
    
    func drive(model: DrivableModelProtocol?) {
        drive(model: model as? TextFieldDrivableModel)
    }
    
    private func drive(model: TextFieldDrivableModel?) {
        guard let model = model else { return }
        
        placeholder = model.placeholder
        returnKeyType = model.returnKey
        textContentType = model.contentType
    }
    
}


