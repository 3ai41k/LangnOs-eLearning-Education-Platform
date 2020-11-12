//
//  TabBarProvider.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

enum TabBarProvider: Int, CaseIterable {
    case dashboard
    case courses
    case messages
    case search
    
    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard".localize
        case .courses:
            return "Courses".localize
        case .messages:
            return "Messages".localize
        case .search:
            return "Search".localize
        }
    }
    
    var unselectedImage: UIImage {
        switch self {
        case .dashboard:
            return UIImage(systemName: "square.split.2x2.fill")!
        case .courses:
            return UIImage(systemName: "book.fill")!
        case .messages:
            return UIImage(systemName: "ellipses.bubble.fill")!
        case .search:
            return SFSymbols.search()
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .dashboard:
            return UIImage(systemName: "square.split.2x2")!
        case .courses:
            return UIImage(systemName: "book")!
        case .messages:
            return UIImage(systemName: "ellipses.bubble")!
        case .search:
            return SFSymbols.search()
        }
    }
    
    func generateCoordinator(parentViewController: UIViewController?) -> Coordinator {
        switch self {
        case .dashboard:
            return DashboardCoordinator(parentViewController: parentViewController)
        case .courses:
            return CoursesCoordinator(parentViewController: parentViewController)
        case .messages:
            return ChatsCoordinator(parentViewController: parentViewController)
        case .search:
            return SearchVocabularyCoordinator(parentViewController: parentViewController)
        }
    }
    
}
