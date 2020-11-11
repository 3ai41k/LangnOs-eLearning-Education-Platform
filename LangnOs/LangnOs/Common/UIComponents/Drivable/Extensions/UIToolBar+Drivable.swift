//
//  UIToolBar+Drivable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 11.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIToolbar: DrivableViewProtocol {
    
    func drive(model: DrivableModelProtocol?) {
        drive(model: model as? ToolbarDrivableModel)
    }
    
    private func drive(model: ToolbarDrivableModel?) {
        setItems(model?.barButtonDrivableModels.compactMap({ UIBarButtonItem(model: $0) }), animated: true)
    }
    
}
