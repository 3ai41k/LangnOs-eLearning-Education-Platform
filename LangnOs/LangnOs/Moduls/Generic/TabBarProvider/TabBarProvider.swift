//
//  TabBarProvider.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

enum TabBarProvider: CaseIterable {
    case main
    
    var title: String {
        switch self {
        case .main:
            return "Home".localize
        }
    }
    
    var unselectedImage: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house.fill")!
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house")!
        }
    }
    
    func generateCoordinator(parentViewController: UIViewController?) -> Coordinator {
        switch self {
        case .main:
            return MainCoordinator(parentViewController: parentViewController)
        }
    }
    
}
