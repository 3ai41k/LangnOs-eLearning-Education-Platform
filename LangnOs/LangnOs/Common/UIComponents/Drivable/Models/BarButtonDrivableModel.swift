//
//  BarButtonDrivableModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

struct BarButtonDrivableModel: DrivableModelProtocol {
    let title: String
    let style: UIBarButtonItem.Style
    let target: Any?
    let selector: Selector?
}
