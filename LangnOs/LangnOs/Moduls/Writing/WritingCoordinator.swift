//
//  WritingCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 18.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol WritingCoordinatorNavigationProtocol {
    func navigateToStudyResult()
}

typealias WritingCoordinatorProtocol =
    WritingCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol
    

final class WritingCoordinator: Coordinator, WritingCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let words: [Word]
    
    // MARK: - Init
    
    init(words: [Word], parentViewController: UIViewController?) {
        self.words = words
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = WritingViewModel(router: self, words: words)
        let viewController = WritingViewController()
        viewController.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.viewController = navigationController
        self.parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - WritingCoordinatorNavigationProtocol
    
    func navigateToStudyResult() {
        let studyResultCoordinator = StudyResultCoordinator(parentViewController: viewController)
        studyResultCoordinator.start()
    }
    
}


