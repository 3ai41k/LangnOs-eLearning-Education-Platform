//
//  UITabBarItem+Init.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UITabBarItem {
    
    convenience init(provider: TabBarProvider) {
        self.init(title: provider.title,
                  image: provider.unselectedImage,
                  selectedImage: provider.selectedImage)
    }
    
}
