//
//  TabBarProvider.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

enum TabBarProvider: Int, CaseIterable {
    case main
    case courses
    case messages
    case account
    
    var title: String {
        switch self {
        case .main:
            return "Home".localize
        case .courses:
            return "Courses".localize
        case .messages:
            return "Messages".localize
        case .account:
            return "Account".localize
        }
    }
    
    var unselectedImage: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house.fill")!
        case .courses:
            return UIImage(systemName: "book.fill")!
        case .messages:
            return UIImage(systemName: "ellipses.bubble.fill")!
        case .account:
            return UIImage(systemName: "person.fill")!
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house")!
        case .courses:
            return UIImage(systemName: "book")!
        case .messages:
            return UIImage(systemName: "ellipses.bubble")!
        case .account:
            return UIImage(systemName: "person")!
        }
    }
    
    var isLoced: Bool {
        switch self {
        case .main:
            return false
        case .courses:
            return true
        case .messages:
            return true
        case .account:
            return false
        }
    }
    
    func generateCoordinator(parentViewController: UIViewController?) -> Coordinator {
        switch self {
        case .main:
            return MainCoordinator(parentViewController: parentViewController)
        case .courses:
            return CoursesCoordinator(parentViewController: parentViewController)
        case .messages:
            return MessagesCoordinator(parentViewController: parentViewController)
        case .account:
            return AccountCoordinator(parentViewController: parentViewController)
        }
    }
    
}
