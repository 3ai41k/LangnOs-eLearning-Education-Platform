//
//  ButtonDrivableModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

struct ButtonDrivableModel: DrivableModelProtocol {
    let title: String
    let titleColor: UIColor
    let target: Any
    let selector: Selector
}
