//
//  NavigationItemDrivableModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct NavigationItemDrivableModel: DrivableModelProtocol {
    let title: String?
    let leftBarButtonDrivableModels: [DrivableModelProtocol]
    let rightBarButtonDrivableModels: [DrivableModelProtocol]
}
